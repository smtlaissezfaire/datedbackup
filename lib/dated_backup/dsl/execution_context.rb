
require File.dirname(__FILE__) + "/main"
require File.dirname(__FILE__) + "/time_extensions"

class DatedBackup
  class DSL
    class ExecutionContext

      def initialize(name, *params, &blk)
        if name == :main
          filename = params.first
          Main.new(filename)
        elsif name == :before || name == :after
          Around.new(&blk)
        end
      end


      class Main

        def initialize(filename)
          Datedbackup::DSL::Main.load(filename)
        end

        def load(filename)

        end

      end

      class Around

        def initialize(&blk)
          instance_eval &blk
        end

        def remove_old(&blk)
          t = DatedBackup::DSL::Main::TimeExtension.new
          t.instance_eval &blk
        end
      end

    end
  end
end