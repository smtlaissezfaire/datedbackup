
require File.dirname(__FILE__) + "/non_escaped"
require File.dirname(__FILE__) + "/pre_parser"

class DatedBackup
  class DSL
    
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
    
    include UtilityFunctions
    
    def initialize
      @data_hash = {}
      @keys = []
    end
    
    def parse!(raw_data)
      @raw_data = raw_data
      @parsed_data = @raw_data.dup

      pre_parse

      each_key_and_value_as_string do |key, value|
        assign_key(key, value)          
      end
    end
    
    def assign_key(key, params_as_string)
      # TODO: this should be more inteligent, to deal with
      # escaping
      key = key.to_sym       
      @data_hash[key] = params_as_string.split ","
    end

  private

  
    def each_key_and_value_as_string
      array = @parsed_data.scan /(.*?)=(.*)/      
      array.each do |kv_pair|
        yield kv_pair
      end
    end
    
    def pre_parse
      @parsed_data = PreParser.new(@parsed_data).pre_parse
    end

  end
end
