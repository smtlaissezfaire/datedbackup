
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
    class PreParser
      
      include ::DatedBackup::DSL::UtilityFunctions
      
      def initialize(string="")
        @raw_data = string
        @parsed_data = @raw_data.dup
      end
      
      def pre_parse
        define_rules do |all_data, non_escaped_data|
          # remove any comments
          non_escaped_data.gsub! /\#.*/, ''
          
          # remove all whitespace between the start of the line, the key, and the key's equal sign
          filter_keys(non_escaped_data) do |key|
            key.gsub! /\s/, ''
          end
          
          # remove the extra newlines
          non_escaped_data.gsub!(/\n\n/, "\n")
          
          # find all lines that end w/ a comma and join with the preceding line
          non_escaped_data.gsub!(/\,\n/,',') # should add a space here

          # remove unnecessary tabs in the escaped values
          filter_values(non_escaped_data) do |val|
            val.gsub! /\t/, ''
          end
          
          # compact the values, so that there is no space in between commas
          filter_values(non_escaped_data) do |val|
            val.gsub! /\s?\,\s/, ','
          end

          # changes to all_data must come last because replacements to 
          # all_data will not affect the object state of the escaped_data
          
          # remove spaces from the start and end of *whole* values
          filter_values(all_data) do |val|
            val.strip!
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