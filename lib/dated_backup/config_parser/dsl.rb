require File.dirname(__FILE__) + "/non_escaped"
require File.dirname(__FILE__) + "/dsl_base"
require File.dirname(__FILE__) + "/pre_parser"


class String
  def remove_literal_escaping!
    self.gsub!(/\%\q\((.*?)\)/) { $1 }
  end
end

class DatedBackup
  class DSL
    class Main < DSL::Base

      class << self

        def parse(file, file_class=File)
          contents = file_class.open(file, "r").read
          obj = new
          obj.parse!(contents)
          obj.data_hash
        end

      end

      attr_reader :raw_data
      attr_reader :data_hash
      attr_reader :parsed_data
      attr_accessor :keys

      def initialize
        @data_hash = {}
        @keys = []
      end

      def parse!(raw_data)
        @raw_data = raw_data
        @parsed_data = @raw_data.dup

        pre_parse

        keys_and_values.each do |key, values| 
          # the (?!...) expressed a no match, and does not assign
          # to the $1,$2..etc variables
          # so the following is intended to split the string by
          # every comma, except when it is surrounded by
          # %q(...)
          values = values.split /(?!\%q\()\,(?!\))/


          values.each do |val|
            val.remove_literal_escaping!
          end

          assign_key(key, values)
        end

      end

      def assign_key(key, *values)
        # TODO: this should be more inteligent, to deal with
        # escaping
        key = key.to_sym       
        @data_hash[key] = *values
      end

    private

      def keys_and_values
        # the regex eliminates all quoted data from the search
        # look at the comments where keys_and_values is called
        return @parsed_data.scan REGEXPS[:keys_and_values]
      end

      def pre_parse
        @parsed_data = PreParser.new(@parsed_data).pre_parse
      end

    end
      
  end
end

