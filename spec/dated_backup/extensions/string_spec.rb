require File.dirname(__FILE__) + "/../../spec_helper"

describe String, "to_time" do
  it "should create a valid time object from the string given" do
    "dir/2006-01-25-12h-00m-32s".to_time.should == Time.gm('2006', 01, 25, 12, 00, 32)
  end
  
  it "should create a valid time object with an absolute path (regression test)" do
    "/var/backups/network/backups/shares/2007-08-03-01h-05m-15s".to_time.should == Time.gm('2007', '08', '03', '01', '05', '15')
  end
  
  it "should raise a TimeError if the String cannot be converted to a Time Object" 
end