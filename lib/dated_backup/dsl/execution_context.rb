module DatedBackup
  class ExecutionContext
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
        def __anonymous_class
          Class.new do
            include DSL::Main
          end
        end
        
        def __new_anonymous_class_instance
          __anonymous_class.new
        end
        
        def __instance_eval_file_in_new_anonymous_class(filename)
          instance = __new_anonymous_class_instance
          instance.instance_eval(File.read(filename))
          instance
        end

        def load(filename)
          instance = __instance_eval_file_in_new_anonymous_class(filename)
          
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
