
module DatedBackup
  class ExecutionContext

    module ExecutionContextHelper
      def anonymous_class_with_loaded_modules(*mods)
        klass = Class.new
        mods.each do |mod|
          klass.send(:include, mod)
        end
        return klass
      end
    end

    def initialize(name, *params, &blk)  
      DatedBackup::Warnings.execute_silently do
        if name == :main
          params.each do |filename|
            Main.load filename
          end
        elsif name == :before || name == :after
          Around.new &blk
        end        
      end
    end
    
    class Main
      class << self

        include ExecutionContextHelper

        def load(filename)
          instance = anonymous_class_with_loaded_modules(DSL::Main).new
          
          File.open filename, "r" do |file|
            instance.instance_eval file.read
          end
          
          @main_instance = DatedBackup::Core.new(instance.procs)
          @main_instance.set_attributes(instance.hash)
          @main_instance.run
        end
        
        attr_reader :main_instance
        alias :core_instance :main_instance
        alias :instance      :main_instance
      end
    end

    class Around
      
      include ExecutionContextHelper

      def initialize(around=self, &blk)
        around.instance_eval &blk
      end
      
      def __anonymous_time_class
        Class.new do
          extend DSL::TimeExtensions::ClassMethods
          include DSL::TimeExtensions
          self.add_all_time_methods
        end
      end
      
      def __eval_in_context(sym=:time, &blk)
        instance = instance_eval("__anonymous_#{sym}_class.new")
        instance.instance_eval do
          instance_eval(&blk)
        end
        instance
      end
      
      def remove_old(&blk)
        instance = __eval_in_context(:time, &blk)
        Core::BackupRemover.remove!(Main.instance.backup_root, instance.kept)
      end
    end
  
  end
end
