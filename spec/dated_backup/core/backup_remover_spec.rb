require File.dirname(__FILE__) + "/../../spec_helper"

describe String, "to_time" do
  it "should create a valid time object from the string given" do
    "dir/2006-01-25-12h-00m-32s".to_time.should == Time.gm('2006', 01, 25, 12, 00, 32)
  end
end

module DatedBackup
  class Core
  
  end
end