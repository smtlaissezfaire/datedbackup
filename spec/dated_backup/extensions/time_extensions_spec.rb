require File.dirname(__FILE__) + "/../../spec_helper"

describe Time, "at the end of day" do
  before :each do
    @time = Time.now
  end
  
  it "should be the the same time as the end of the next day, minus one second" do
    @time.at_end_of_day.should == @time.tomorrow.beginning_of_day - 1
  end
  
  it "should be the same as end_of_day" do
    @time.end_of_day.should == @time.at_end_of_day
  end
end

describe Time, "at the end of month" do
  before :each do
    @time = Time.now
    @delta_time = Time.now - Time.now
  end
  
  it "should be the the same time as the end of the next month, minus one second" do
    @time.at_end_of_month.should == @time.next_month.beginning_of_month - 1
  end
  
  it "should be the same as end_of_month" do
    @time.end_of_month.should == @time.at_end_of_month
  end
end

describe Time, "at the end of year" do
  before :each do
    @time = Time.now
  end
  
  it "should be the the same time as the end of the next year, minus one second" do
    @time.at_end_of_year.should == @time.next_year.beginning_of_year - 1
  end
  
  it "should be the same as end_of_year" do
    @time.end_of_year.should == @time.at_end_of_year
  end
end


describe Time, "at the end of week" do
  before :each do
    @time = Time.now
  end
  
  it "should be the the same time as the end of the next week, minus one second" do
    @time.at_end_of_week.should == @time.next_week.beginning_of_week - 1
  end
  
  it "should be the same as end_of_week" do
    @time.end_of_week.should == @time.at_end_of_week
  end
end

describe Time, "last week" do
  before :each do
    @time = Time.now
  end
  
  it "should be equal to the beginning of last week" do
    @time.last_week.should == 1.week.ago.beginning_of_week
  end
end

describe Time, "week range" do
  before :each do
    @time = Time.now
  end
  
  it "should return a range of time this week" do
    @time.week.should == (@time.beginning_of_week...@time.end_of_week)
  end
end

describe Time, "each_day_in_month iterator" do
  before :each do
    @collector = []
  end
  
  it "should yield each day in the month if starting with the first day in the month" do
    @t = Time.gm('2007', '07', '01')
    @day = 01

    @t.each_day_in_month do |time|
      time.day.should == @day
      @day += 1
    end
  end
  
  it "should yield each day in the month if starting with any other day in the month" do
    @t = Time.gm('2007', '07', '18')
    @counter = 1
    
    @t.each_day_in_month do |time|
      time.should == Time.gm('2007', '07', @counter)
      @counter += 1
    end
  end
end