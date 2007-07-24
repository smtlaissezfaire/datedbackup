require File.dirname(__FILE__) + "/../spec_helper"


describe "A method which has an equivalent plural alias", :shared => true do
  it "should respond to the plural version" do
    @extention.should respond_to("#{@method_name}s".to_sym)
  end
  
  it "should equal the same value as the singular form" do
    @extention.send("#{@method_name}s".to_sym).should == @extention.send(@method_name)
  end
end

describe "A method which returns self", :shared => true do
  it "should return self" do
    @extention.send(@method_name, nil).should == @extention
  end
end

describe "A method which is responded to", :shared => true do
  it do
    @extention.should respond_to(@method_name)
  end
end


describe DatedBackup::DirectoryTimeExtentions, "backup" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :backup
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
end

describe DatedBackup::DirectoryTimeExtentions, "other" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :backup
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
end

describe DatedBackup::DirectoryTimeExtentions, "week" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :week
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"

  it "should set the last time value to a the :week symbol" do
    @extention.week
    @extention.last_time.should == :week
  end  
end

describe DatedBackup::DirectoryTimeExtentions, "day" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :day
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :day" do
    @extention.day
    @extention.last_time.should == :day
  end
end

describe DatedBackup::DirectoryTimeExtentions, "months" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :month
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :month" do
    @extention.month
    @extention.last_time.should == :month
  end
end

describe DatedBackup::DirectoryTimeExtentions, "year" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :year
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"  
  it_should_behave_like "A method which has an equivalent plural alias"
  
  it "should set the last time value to :year" do
    @extention.year
    @extention.last_time.should == :year
  end
end

describe DatedBackup::DirectoryTimeExtentions, "keeping" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @t = Time.now
    @time_range = @t.at_beginning_of_week...@t
    @method_name = :keep
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  
  it "should append the current time_range hash unto the array it has build" do
    @extention.instance_variable_set("@time_range", {:constraint => @time_range})
    @extention.time_range.should == {:constraint => @time_range}
    
    @extention.kept.should == []
    @extention.keep(@extention.week, @t)
    @extention.kept.should == [{:constraint => @time_range}]
  end
  
  it "should return the TimeRange array to it\'s initial state" do
    @extention.instance_variable_set("@time_range", {:constraint => @time_range})
    @extention.time_range.should == {:constraint => @time_range}
        
    @extention.keep(@extention.week, @t)
    @extention.time_range.should == []
  end
  
  it "should return the last_time to it\'s initial state" do
    @extention.instance_variable_set("@time_range", {:constraint => @time_range})
    @extention.time_range.should == {:constraint => @time_range}
    
    @extention.keep(@extention.week, @t)
    @extention.last_time.should == nil
  end
  
  it "should apply the :all constraint if no other constraint is present" do
    @extention.instance_variable_set("@time_range", Hash.new)
    @extention.time_range.should == {}
    @extention.keep(nil, @t)
    @extention.kept.should == [{:constraint => Time.epoch...@t}]
  end
end

describe DatedBackup::DirectoryTimeExtentions, "this" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @t = Time.now
    @method_name = :this
  end
  
  it "should return self" do
    @extention.this(@extention.week, @t).should == @extention
  end

  it_should_behave_like "A method which is responded to"  
  
  it "should add this week to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_week...@t
    @extention.this(@extention.week, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this day to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_day...@t
    @extention.this(@extention.day, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this month to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_month...@t
    @extention.this(@extention.month, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add this year to the time_range array with a :constraint => timerange hash" do
    @time_range = @t.at_beginning_of_year...@t
    @extention.this(@extention.year, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
end


describe DatedBackup::DirectoryTimeExtentions, "last" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @t = Time.now
    @method_name = :last
  end
  
  it "should return self" do
    @extention.last(@extention.week, @t).should == @extention
  end
  
  it_should_behave_like "A method which is responded to"  
  
  it "should add the last week to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_week.beginning_of_week...@t.last_week.end_of_week
    @extention.last(@extention.week, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last day to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.yesterday.at_beginning_of_day...@t.yesterday.end_of_day
    @extention.last(@extention.day, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last month to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_month.at_beginning_of_month...@t.last_month.end_of_month
    @extention.last(@extention.month, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
  
  it "should add the last year to the time_range array in a :constraint => timerange hash" do
    @time_range = @t.last_year.at_beginning_of_year...@t.last_year.end_of_year
    @extention.last(@extention.year, @t)
    @extention.time_range.should == {:constraint => @time_range}
  end
end

describe DatedBackup::DirectoryTimeExtentions, "the *ly methods" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
  end
  
  it "should add type => :daily unto the time_range hash" do
    @extention.time_range.should == {}
    @extention.daily
    @extention.time_range.should == {:type => :daily}
  end
  
  it "should add type => :weekly unto the time_range hash" do
    @extention.time_range.should == {}
    @extention.weekly
    @extention.time_range.should == {:type => :weekly}
  end
  
  it "should add type => :monthly unto the time_range hash" do
    @extention.time_range.should == {}
    @extention.monthly
    @extention.time_range.should == {:type => :monthly}
  end
  
  it "should add type => :yearly unto the time_range hash" do
    @extention.time_range.should == {}
    @extention.yearly
    @extention.time_range.should == {:type => :yearly}
  end
end

describe DatedBackup::DirectoryTimeExtentions, "from" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :from
  end
  
  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
end

describe DatedBackup::DirectoryTimeExtentions, "all" do
  before :each do
    @extention = DatedBackup::DirectoryTimeExtentions.new
    @method_name = :all
    @t = Time.now
  end

  it_should_behave_like "A method which returns self"
  it_should_behave_like "A method which is responded to"
  
  it "should set the constrait from Jan 1970 to now" do
    @extention.all(nil, @t)
    @extention.time_range.should == {:constraint => Time.epoch...@t}
  end
end