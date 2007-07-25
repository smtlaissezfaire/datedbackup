
require File.dirname(__FILE__) + "/main"
require File.dirname(__FILE__) + "/time_extensions"

class DatedBackup
  class ExecutionContext

    def initialize(name, *params, &blk)
      
      if name == :main
        filename = params.first
        Main.load filename
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
            contents = file.read
            instance.instance_eval contents
          end
          
          dated_backup = DatedBackup.new(instance.procs)
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