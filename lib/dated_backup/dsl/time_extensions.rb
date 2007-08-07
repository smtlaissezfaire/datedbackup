
module DatedBackup
  class DSL
    
    # After a run through the DSL,
    # the TimeExtensions#kept method should contain an array
    # of all of the items to keep.  Each item will be a hash
    # with two keys: a :constraint key, which contains a 
    # range of Times (from oldest to newest), and a :scope
    # key, which will indicate whether the backup to look
    # at is a weekly, monthly, etc.  If no :scope key is given,
    # then all of the backups in the time range given by
    # the :constraint key will be assumed to be kept.
    module TimeExtensions
      
      module ClassMethods
        
        # Adds all of the TimeSymbol methods, like
        # day, days, daily, and dailies
        def add_all_time_methods
          add_singular_time_methods
          add_plural_time_methods
          add_plural_adverbial_time_methods
          add_singular_adverbial_time_methods
        end
        
      protected
        
        # Adds the methods:
        # * year
        # * month
        # * day
        # * week
        def add_singular_time_methods
          each_time_symbol do |time_sym|
            define_method time_sym.singular do |*args|
              self.send :time_component, time_sym.singular
            end                      
          end  
        end

        # Adds the methods:
        # * years
        # * months
        # * days
        # * weeks        
        def add_plural_time_methods
          each_time_symbol do |time_sym|
            alias_method time_sym.plural, time_sym.singular        
          end
        end
        
        # Adds the methods:
        # * yearlies
        # * monthlies
        # * dailies
        # * weeklies
        def add_plural_adverbial_time_methods
          each_time_symbol do |time_sym|
            alias_method time_sym.plural_adverb, time_sym.singular
          end
        end

        # Adds the methods:
        # * yearly
        # * monthly
        # * daily
        # * weekly
        def add_singular_adverbial_time_methods
          each_time_symbol do |time_sym|
            define_method time_sym.adverb do
              @time_range[:scope] = time_sym.adverb
            end
          end
        end
                
        # A helper method to which yields each time
        # symbol as a time symbol       
        def each_time_symbol(&blk)
          TimeSymbol.valid_symbols.each do |sym|
            yield(TimeSymbol.new(sym))
          end
        end
      end
      
      attr_reader :last_time, :time_range
      attr_reader :kept

      def initialize
        @kept = []
        @time_range = {}
        @last_time = nil      
      end

      # placeholders:
      def backup  *args;   return self; end
      def from    *args;   return self; end
      
      def this arg, now=Time.now
        set_time_range :this, now
      end

      def last arg, now=Time.now
        set_time_range :last, now
      end
      
      def today(arg=nil, now=Time.now)
        this(day, now)
      end
      
      def yesterday(arg=nil, now=Time.now)
        last(day, now)
      end

      def keep arg, now=Time.now
        all(self, now) unless time_range[:constraint]

        @kept << time_range
        reset_times
        self
      end

      def all arg=self, now=Time.now
        @time_range[:constraint] = Time.epoch...now
        self
      end
      
      def ==(obj)
        # return false if obj is not a kind_of this class
        self.instance_variables.each do |iv|
          return false if self.instance_variable_get(iv) != obj.instance_variable_get(iv)
        end
        true
      end

      # convenient aliases:
      alias :todays :today
      alias :yesterdays :yesterday
      alias :backups :backup

    protected

      def set_time_range sym, now
        if sym == :last
          year, month, week, day = now.last_year, now.last_month, now.last_week, now.yesterday
        elsif sym == :this
          add_end_of_star_singletons(now)

          # This is another little trick.  Normally we would just call the methods
          # below something like: Time.now.beginning_of_year...Time.now.end_of_year
          year, month, week, day = now, now, now, now
        end

        @time_range[:constraint] = 
          case last_time
          when :year
            year.beginning_of_year...year.end_of_year
          when :month
            month.beginning_of_month...month.end_of_month
          when :week
            week.beginning_of_week...week.end_of_week
          when :day
            day.beginning_of_day...day.end_of_day
          end

        self
      end

      # This method adds the end_of_* methods to the object passed in.  They are used in the default case
      # of the modifyer being "this" and not "last".  In the 'this' case, the time
      # *is* now, so end_of_* (end_of_year, end_of_day), etc. should *NOT* need to be called
      # (and in fact, we do not want them to be called, because that would represent
      # some time period in the future).  Those methods are overrided to return self
      def add_end_of_star_singletons(now)
        class << now
          [:end_of_year, :end_of_month, :end_of_week, :end_of_day].each do |end_of|
            define_method end_of do
              return self
            end
          end
        end      
      end

      def time_component(type)
        @last_time = type
        self
      end

      def reset_times
        @time_range = {}
        @last_time = nil      
      end
    end
    
  end
end
