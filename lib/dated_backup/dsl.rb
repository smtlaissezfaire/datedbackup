
class InvalidKeyError < RuntimeError; end

class DatedBackup
  class DSL
    
    class << self
      def load(filename)
        new.load(filename)
      end
    end
    
    attr_reader :hash
    
    def initialize
      @hash = {}
    end
    
    def load(filename)
      File.open(filename) do |f|
        self.instance_eval f.read
      end

      dated_backup = DatedBackup.new
      dated_backup.set_attributes(hash) 
      dated_backup.run
    end
    
    def method_missing(sym, *args)
      if RSYNC_OPTIONS.include?(sym)
        @hash[sym] = args
      else
        raise InvalidKeyError, "The key '#{sym}' is not a recognized expression"
      end
    end
    
  protected
    
    RSYNC_OPTIONS = [:source, :sources, :destination, :options, :user_domain]
    
  end
end