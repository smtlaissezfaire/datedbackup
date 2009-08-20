require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe DatedBackup::Warnings, "executing silently" do
  before :each do
    @warnings = $VERBOSE
  end
  
  
  it "should turn off warnings" do
    $VERBOSE.should == @warnings
    
    DatedBackup::Warnings.execute_silently do
      $VERBOSE.should == nil
    end
    
    $VERBOSE.should == @warnings
  end

end