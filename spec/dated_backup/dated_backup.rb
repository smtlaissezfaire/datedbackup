require File.dirname(__FILE__) + "/../spec_helper"

describe DatedBackup, "accessor methods" do
  it "should have source directory as array if only one provided" do
    DatedBackup.new(:source => "dir").sources.should == ["dir"]
  end
  
  it "should have source directories as array if many provided" do
    DatedBackup.new(:sources => ["dir1", "dir2"]).sources.should == ["dir1", "dir2"]
  end
  
  it "should assign the original destination as the backup_root" do
    DatedBackup.new(:destination => "dest").backup_root.should == "dest"
  end
  
  it "should have the options as a string" do
    DatedBackup.new(:options => "opt1, opt2").options.should == "opt1, opt2"
  end
  
  it "should have the destination as the destination dir/timestamp" do
    time = Time.now
    time_format = time.strftime "%Y-%m-%d-%Hh-%Mm-%Ss"
    
    DatedBackup.new(:destination => "dest").destination.should == "dest/#{time_format}"
  end
end