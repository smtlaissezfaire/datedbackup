

class ParseError < RuntimeError;  end

class DatedBackup 
  class DSL
    
    attr_reader :data_hash, :config_data, :backup_class
    
    def initialize(bkup=DatedBackup)
      @data_hash = {}
      @backup_class = bkup
    end
      
    def parse(config_file_data)
      @config_data = config_file_data
      split_data
    end
    
    def run
      backup_class.new(data_hash).run
    end
    
  private 
  
    def strip_spaces(data)
      if data.empty?
        ""
      elsif data =~ /\,|\=/
         # &` = pre match
         # $& = matched data
         # $' = post match
         strip_spaces($`) + $& + strip_spaces($')
      else
        data.chomp.strip
      end
    end

    def split_data
      #split all newlines, except those that end with a comma
      @split_data = strip_spaces(config_data).chomp
      
      @split_data.each do |data_line|
        # split the line by key & value, and strip the whitespace
        # from each of them
        key, value = data_line.split("=").map { |k| k.strip }
        values = value.split(",").map { |k| k.strip }
        
        @data_hash[key.to_sym] = values
      end
    end
    
  end
end