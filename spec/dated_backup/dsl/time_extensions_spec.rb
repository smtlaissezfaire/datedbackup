require File.dirname(__FILE__) + "/../../spec_helper"

TimeExtension = Class.new
TimeExtension.class_eval do
  include DatedBackup::DSL::TimeExtensions
end

describe "A method which has an equivalent plural alias", :shared => true do
  it "should respond to the plural version" do
    @extension.should respond_to("#{@method_name}s".to_sym)
  end
  
  it "should equal the same value as the singular form" do
    @extension.send("#{@method_name}s".to_sym).should == @extension.send(@method_name)
  end
end

describe "A method which has an equivalent singular alias", :shared => true do
  before :each do
    @singular_name = @method_name.to_s
    @singular_name = @singular_name[0..@singular_name.size-2]
  end
  
  it "should respond to the singular version" do
    @extension.should respond_to?("#{@singular_name}.to_sym")
  end
  
  it "should equal the same value as the plural form" do
    @extension.send(@singular_name.to_sym).should == @extension.send(@method_name.to_sym)
  end
end

describe "A method which returns self", :shared => true do
  it "should return self" do
    @extension.send(@method_name, nil).should == @extension
  end
end

describe "A method which is responded to", :shared => true do
  it do
    @extension.should respond_to(@method_name)
  end
end


describe TimeExtension, "backup" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :backup
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
end

describe TimeExtension, "other" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :backup
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
end

describe TimeExtension, "week" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :week
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"

  it "should set the last time value to a the :week symbol" do
    @extension.week
    @extension.last_time.should == :week
  end  
end

describe TimeExtension, "weeklies" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :weeklies
  end
  
  it "should set the last time value to the :week symbol" do
    @extension.weeklies
    @extension.last_time.should == :week
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end

describe TimeExtension, "monthlies" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :monthlies
  end

  it "should set the last time value to the :month symbol" do
    @extension.monthlies
    @extension.last_time.should == :month
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end

describe TimeExtension, "dailies" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :dailies
  end
  
  it "should set the last time value to the :day symbol" do
    @extension.dailies
    @extension.last_time.should == :day
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end

describe TimeExtension, "yearlies" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :yearlies
  end
  
  it "should set the last time value to the :year symbol" do
    @extension.yearlies
    @extension.last_time.should == :year
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end


describe TimeExtension, "day" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :day
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :day" do
    @extension.day
    @extension.last_time.should == :day
  end
end

describe TimeExtension, "months" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :month
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :month" do
    @extension.month
    @extension.last_time.should == :month
  end
end

describe TimeExtension, "year" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :year
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"  
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :year" do
    @extension.year
    @extension.last_time.should == :year
  end
end

describe "A method which is callable with one or no arguments", :shared => true do
  it "should be callable with no arguments" do
    @extension.instance_eval "keep #{@method_name}"
  end
  
  it "should be callable with one argument" do
    @extension.instance_eval "keep #{@method_name} backups"
  end
end

describe TimeExtension, "todays" do
  before :each do
    @extension = TimeExtension.new
    @extension_two = TimeExtension.new
    @method_name = :todays
    @time = Time.now
    Time.stub!(:now).and_return @time
  end
  
  it "should act like this_day" do
    @extension_two.instance_eval do
      keep this days backups
    end
    
    @extension.instance_eval do
      keep todays backups
    end
    
    @extension.should == @extension_two
  end
  
  it_should_behave_like "A method which is callable with one or no arguments"
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"  
  it_should_behave_like "A method which has an equivalent singular alias"
end

describe TimeExtension, "yesterdays" do
  before :each do
    @extension = TimeExtension.new
    @extension_two = TimeExtension.new
    
    @method_name = :yesterdays
    @time = Time.now
    Time.stub!(:now).and_return @time
  end
  
  it "should act like last(day)" do
    @extension.instance_eval do
      keep yesterdays backups
    end
    
    @extension_two.instance_eval do
      keep last days backups
    end
    
    @extension.should == @extension_two
  end
  
  it_should_behave_like "A method which is callable with one or no arguments"
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent singular alias"
end


describe TimeExtension, "object with #==" do
  before :each do
    @obj_one = TimeExtension.new
    @obj_two = TimeExtension.new

    @now = Time.now
    Time.stub!(:now).and_return @now
  end
  
  it "should be equal to the other object if nothing has been done to either object" do
    @obj_one.should == @obj_two
  end
  
  it "should not be equal to the other object if something has been done to the object, but not to the other" do
    @obj_one.instance_eval do
      keep monthly backups
    end
    
    @obj_one.should_not == @obj_two
  end
  
  it "should not be equal to the other object if something has been done to the other object, but not to this one" do
    @obj_two.instance_eval do
      keep monthly backups
    end
    
    @obj_one.should_not == @obj_two
    @obj_two.should_not == @obj_one
  end
  
  it "should be equal to the other object if the same method calls have been performed on both objects" do    
    @obj_one.instance_eval do
      keep monthly backups
    end
    
    @obj_two.instance_eval do
      keep monthly backups
    end
    
    @obj_one.should == @obj_two
  end
  
  it "should be equal to the other object if equivalent method calls have been peformed on both objects" do
    @obj_one.instance_eval do
      keep backups from today
    end
    
    @obj_two.instance_eval do
      keep backups from this day
    end
    
    @obj_one.should == @obj_two
  end
end

describe TimeExtension, "keeping" do
  before :each do
    @extension = TimeExtension.new
    @t = Time.now
    @time_range = @t.at_beginning_of_week...@t
    @method_name = :keep
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  
  it "should append the current time_range hash unto the array it has build" do
    @extension.instance_variable_set("@time_range", {:constraint => @time_range})
    @extension.time_range.should == {:constraint => @time_range}
    
    @extension.kept.should == []
    @extension.keep(@extension.week, @t)
    @extension.kept.should == [{:constraint => @time_range}]
  end
  
  it "should return the TimeRange array to it\'s initial state" do
    @extension.instance_variable_set("@time_range", {:constraint => @time_range})
    @extension.time_range.should == {:constraint => @time_range}
        
    @extension.keep(@extension.week, @t)
    @extension.time_range.should == {}
  end
  
  it "should return the last_time to it\'s initial state" do
    @extension.instance_variable_set("@time_range", {:constraint => @time_range})
    @extension.time_range.should == {:constraint => @time_range}
    
    @extension.keep(@extension.week, @t)
    @extension.last_time.should == nil
  end
  
  it "should apply the :all constraint if no other constraint is present" do
    @extension.instance_variable_set("@time_range", Hash.new)
    @extension.time_range.should == {}
    @extension.keep(nil, @t)
    @extension.kept.should == [{:constraint => Time.epoch...@t}]
  end
end

describe TimeExtension, "this" do
  before :each do
    @extension = TimeExtension.new
    @t = Time.now
    @method_name = :this
  end
  
  it "should return self" do
    @extension.this(@extension.week, @t).should == @extension
  end

  it_should_behave_like "A method which is responded to"  
  
  it "should add this week to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_week...@t
    @extension.this(@extension.week, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this day to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_day...@t
    @extension.this(@extension.day, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this month to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_month...@t
    @extension.this(@extension.month, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this year to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_year...@t
    @extension.this(@extension.year, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
end


describe TimeExtension, "last" do
  before :each do
    @extension = TimeExtension.new
    @t = Time.now
    @method_name = :last
  end
  
  it "should return self" do
    @extension.last(@extension.week, @t).should == @extension
  end
  
  it_should_behave_like "A method which is responded to"  
  
  it "should add the last week to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_week.beginning_of_week...@t.last_week.end_of_week
    @extension.last(@extension.week, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last day to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.yesterday.at_beginning_of_day...@t.yesterday.end_of_day
    @extension.last(@extension.day, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last month to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_month.at_beginning_of_month...@t.last_month.end_of_month
    @extension.last(@extension.month, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last year to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_year.at_beginning_of_year...@t.last_year.end_of_year
    @extension.last(@extension.year, @t)
    @extension.time_range.should == {:constraint => @time_range}
  end
end

describe TimeExtension, "the *ly methods" do
  before :each do
    @extension = TimeExtension.new
  end
  
  it "should add type => :daily unto the time_range hash" do
    @extension.time_range.should == {}
    @extension.daily
    @extension.time_range.should == {:scope => :daily}
  end
  
  it "should add type => :weekly unto the time_range hash" do
    @extension.time_range.should == {}
    @extension.weekly
    @extension.time_range.should == {:scope => :weekly}
  end
  
  it "should add type => :monthly unto the time_range hash" do
    @extension.time_range.should == {}
    @extension.monthly
    @extension.time_range.should == {:scope => :monthly}
  end
  
  it "should add type => :yearly unto the time_range hash" do
    @extension.time_range.should == {}
    @extension.yearly
    @extension.time_range.should == {:scope => :yearly}
  end
end

describe TimeExtension, "from" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :from
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end

describe TimeExtension, "all" do
  before :each do
    @extension = TimeExtension.new
    @method_name = :all
    @t = Time.now
  end

  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  
  it "should set the constrait from Jan 1970 to now" do
    @extension.all(nil, @t)
    @extension.time_range.should == {:constraint => Time.epoch...@t}
  end
end