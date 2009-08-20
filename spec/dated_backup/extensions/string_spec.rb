require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe String, "to_time" do
  it "should create a valid time object from the string given" do
    "dir/2006-01-25-12h-00m-32s".to_time.should == Time.gm('2006', 01, 25, 12, 00, 32)
  end
  
  it "should create a valid time object with an absolute path (regression test)" do
    "/var/backups/network/backups/shares/2007-08-03-01h-05m-15s".to_time.should == Time.gm('2007', '08', '03', '01', '05', '15')
  end
  
  it "should raise a StringToTimeConversionError if the String cannot be converted to a Time Object" do
    lambda { 
      "gobbly-gookhms0000-00asdfad-m00s".to_time
    }.should raise_error(StringToTimeConversionError, "The string cannot be converted to a time object")
  end
  
  it "should raise a StringToTimeConversionError if the String contains a time which would raise a time out of range error" do
    lambda {
      "/var/1750-00-00-00h-00m-00s".to_time
    }.should raise_error(StringToTimeConversionError, "The string cannot be a converted to a valid time (it is out of range)")
  end
end