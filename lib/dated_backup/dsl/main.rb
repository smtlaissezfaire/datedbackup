
class NoBlockGiven < RuntimeError; end
class InvalidKeyError < RuntimeError; end

class DatedBackup
  class DSL
    module Main
      #class << self
      #  def load(filename)
      #    new.load(filename)
      #  end
      #end

      attr_reader :hash, :procs

      def initialize
        @hash = {}
        @procs = {}
      end

      #def load filename 
      #  File.open(filename) do |f|
      #    self.instance_eval f.read
      #  end
      #
      #  dated_backup = DatedBackup.new(procs)
      #  dated_backup.set_attributes(hash) 
      #  dated_backup.run
      #end

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