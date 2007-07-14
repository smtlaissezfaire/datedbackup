
class Integer
  def odd?
    !even
  end
  
  def even?
    (self % 2) == 0 ? true : false
  end
end


class DatedBackup
  class DSL
    class PreParser < DSL::Base

      
      def initialize(string="")
        @raw_data = string
        @parsed_data = @raw_data.dup
      end
      
      def pre_parse
        define_rules do |all_data, non_escaped_data|
          # remove any comments
          non_escaped_data.gsub! /\#.*/, ''
          
          # remove the extra newlines
          non_escaped_data.gsub!(/\n\n/, "\n")
          
          # find all lines that end w/ a comma and join with the preceding line
          non_escaped_data.gsub!(/\,\s*\n/,',')

          # remove unnecessary tabs in the whole file
          non_escaped_data.gsub!(/\t/, '')
          
          # compact the values, so that there is no space in between commas
          filter_values(non_escaped_data, :with_spaces => true) do |val|
            val.gsub! /\s?\,\s/, ','
          end

          # changes to all_data must come last because replacements to 
          # all_data will not affect the object state of the escaped_data         
          # remove spaces from the start and end of *whole* values
          filter_values(all_data, :with_spaces => true) do |val|
            val.strip!
          end
          
          filter_keys(all_data, :with_spaces => true) do |key|
            key.strip!
          end
          
        end
      end
      
    private
      
      def define_rules
        non_escaped_data(@parsed_data) do |normal_data|
          yield @parsed_data, normal_data
        end
        
        @parsed_data
      end
    end

  end
end
