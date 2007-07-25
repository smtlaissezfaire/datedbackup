
class DatedBackup
  class DSL
    module TimeExtensions

      attr_reader :last_time, :time_range
      attr_reader :kept

      def initialize
        @kept = []
        @time_range = {}
        @last_time = nil      
      end

      def backup  *args;   return self; end
      def from    *args;   return self; end

      alias :backups :backup

      VALID_TIME_COMPONENTS = [:day, :week, :month, :year]

      VALID_TIME_COMPONENTS.each do |t|
        singular = t.to_sym
        plural = "#{t}s".to_sym
        adverb = t == :day ? :daily : "#{t}ly".to_sym

        # To create the singular method, i.e. 'day', 'month'
        define_method singular do |*args|
          self.send :time_component, singular
        end

        # An alias for the plural, i.e. 'days', 'weeks'
        alias_method plural, singular

        # the adverbial form, i.e. 'daily', 'weekly'        
        define_method adverb do
          @time_range[:type] = adverb
        end
      end

      def this arg, now=Time.now
        set_time_range :this, now
      end

      def last arg, now=Time.now
        set_time_range :last, now
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
        @time_range = []
        @last_time = nil      
      end
    end
    
  end
end
