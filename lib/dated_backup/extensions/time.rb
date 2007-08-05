require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/numeric/time'

class Time
  class << self
    include ActiveSupport::CoreExtensions::Time::Calculations::ClassMethods  	
    
    def epoch
      Time.at(0)
    end
    
  end
  
  include ActiveSupport::CoreExtensions::Time::Calculations
  
  def end_of_day
    tomorrow.beginning_of_day - 1
  end
  
  def end_of_month
    next_month.beginning_of_month - 1
  end
  
  def end_of_year
    next_year.beginning_of_year - 1
  end
  
  def end_of_week
    next_week.beginning_of_week - 1
  end
  
  def last_week
    1.week.ago.beginning_of_week
  end
  
  alias :at_end_of_week  :end_of_week
  alias :at_end_of_month :end_of_month
  alias :at_end_of_day   :end_of_day
  alias :at_end_of_year  :end_of_year
  
  def week
    beginning_of_week...end_of_week
  end
  
  def each_day_in_month
    1.upto(days_in_month) do |day_num|
      yield beginning_of_month + (day_num - 1).day
    end
  end
  
  def days_in_month
    self.class.days_in_month(self.month, self.year)
  end
  
end

class Fixnum
  include ActiveSupport::CoreExtensions::Numeric::Time
end

