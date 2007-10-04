
module DatedBackup
  class DSL
    module Main

      attr_reader :hash, :procs

      def initialize
        @hash = {}
        @procs = {}
      end

      def before &blk
        raise_without_block &blk
        @procs[:before] = blk
      end

      def after &blk
        raise_without_block &blk
        @procs[:after] = blk
      end

      def method_missing sym, *args
        if RSYNC_OPTIONS.include?(sym)
          @hash[sym] = args
        else
          raise InvalidKeyError, "The key '#{sym}' is not a recognized expression"
        end
      end

    private

      def raise_without_block &blk
        raise NoBlockGiven, "A block (do...end) must be given" if !block_given?
      end

      RSYNC_OPTIONS = [:source, :sources, :destination, :options, :user_domain] unless const_defined?("RSYNC_OPTIONS")

    end      
  end
end