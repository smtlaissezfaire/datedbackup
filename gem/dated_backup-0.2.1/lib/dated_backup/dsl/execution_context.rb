
module DatedBackup
  class ExecutionContext

    module ExecutionContextHelper
      def anonymous_instance_loading_module(mod)
        klass = Class.new
        klass.send(:include, mod)
        klass.new
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
          instance = anonymous_instance_loading_module(DSL::Main)         
          
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

      def remove_old(&blk)
        instance = anonymous_instance_loading_module(DSL::TimeExtensions)
        instance.instance_eval &blk
        Core::BackupRemover.remove!(Main.instance.backup_root, instance.kept)
      end
    end
  
  end
end
