
class DatedBackup
  class ExecutionContext

    def initialize(name, *params, &blk)  
      if name == :main
        params.each do |filename|
          Main.load filename
        end
      elsif name == :before || name == :after
        Around.new &blk
      end
    end
    
    class Main
      class << self
        def load(filename)
          klass = Class.new
          klass.include ::DatedBackup::DSL::Main
          instance = klass.new          
          
          File.open filename, "r" do |file|
            instance.instance_eval file.read
          end
          
          dated_backup = DatedBackup::Core.new(instance.procs)
          dated_backup.set_attributes(instance.hash)
          dated_backup.run
        end
      end
    end

    class Around
      def initialize(around=self, &blk)
        around.instance_eval &blk
      end

      def remove_old(&blk)
        klass = Class.new
        klass.include ::DatedBackup::DSL::TimeExtensions
        instance = klass.new

        instance.instance_eval &blk
      end
    end
  
  end
end
