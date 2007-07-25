
class DatedBackup
  class DSL
    module Main

      attr_reader :hash, :procs

      def initialize
        @hash = {}
        @procs = {}
      end

      def before &blk
        raise_without_block if !block_given?
        @procs[:before] = blk
      end

      def after &blk
        raise_without_block if !block_given?
        @procs[:after] = blk
      end

      def method_missing sym, *args
        if RSYNC_OPTIONS.include?(sym)
          @hash[sym] = args
        else
          raise InvalidKeyError, "The key '#{sym}' is not a recognized expression"
        end
      end

    protected

      def raise_without_block
        raise NoBlockGiven, "A block (do...end) must be given"
      end

      RSYNC_OPTIONS = [:source, :sources, :destination, :options, :user_domain]

    end      
  end
end