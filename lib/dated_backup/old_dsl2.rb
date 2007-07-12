
class DatedBackup
  class DSL
    attr_reader :raw_data
    attr_reader :data_hash
    attr_reader :keys
    
    def initialize
      @data_hash = {}
      @keys = []
    end
    
    def keys= args
      @keys = args
      
      sclass = class << self; self; end
      
      @keys.each do |key|      
        sclass.class_eval do
          define_method "#{key}=" do |val|
            @data_hash[key] = "#{val}"
          end
        end
      end
      
      @keys
    end
    
    def parse!(raw_data)
      instance_eval raw_data
    end
    
    def method_missing(sym, *args)
      if args.empty?
        "#{sym}"
      else
        super
      end
        
    end
  end
end

#require 'rubygems'; require 'ruby-debug'; debugger;
#d = DatedBackup::DSL.new
#d.keys = [:key1, :key2]
#d.key1 = val