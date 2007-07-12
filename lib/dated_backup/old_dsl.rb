
# how about instance evaling inside a class?
# call method missing


class ParseError < RuntimeError;  end

class String
  def escape
    self.gsub /\"/, "\""
  end
  
end

class DatedBackup 
  
  class DSL

    class << self

      def run(config_file_data, dsl_class=DSL, bkup_class=DatedBackup)
        new(bkup_class).parse.run
      end

    end
    
    attr_reader :data_hash, :config_data, :backup_class
    
    def initialize(bkup_class=DatedBackup)
      @data_hash = {}
      @backup_class = bkup_class
    end
      
    def parse(config_file_data)
      @config_data = config_file_data
      
      #begin 
        split_data
      #rescue 
      #  raise ParseError
      #end
    end
    
    def run
      backup_class.new(data_hash).run
    end
    
  private 
  
    def strip_spaces(data)
      if data.nil? || data.empty?
        ""
      elsif data =~ /\n\n/
        strip_spaces($`) + "\n" + strip_spaces($')
      elsif data =~ /\,|\=/
         # &` = pre match
         # $& = matched data
         # $' = post match
         strip_spaces($`) + $& + strip_spaces($')
      else
        data.chomp.strip
      end
    end
    
    def strip_newlines_after_comma
      @split_data.gsub /\,\n+/, ','
    end
    

    def split_data
      #split all newlines, except those that end with a comma
      @split_data = strip_spaces(config_data).chomp
      strip_newlines_after_comma
      
      
      @split_data.each do |data_line|
        unless data_line.empty?
        
          # split the line by key & value, and strip the whitespace
          # from each of them
          begin
            key, value = data_line.split(/\=/).map { |k| k.strip }
            values = value.split(",").map { |k| k.strip }
        
            @data_hash[key.to_sym] = values
          rescue
            raise ParseError, "No key-value pair found in #{data_line.to_yaml}"
          end
        end
      end
    end
    
  end
end