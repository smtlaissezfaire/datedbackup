
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

      def remove_old(&blk)
        klass = anonymous_class_with_loaded_modules(DSL::TimeExtensions)
        instance = klass.new
        instance.instance_eval &blk
        Core::BackupRemover.remove!(Main.instance.backup_root, instance.kept)
      end
    end
  
  end
end
