require File.dirname(__FILE__) + "/../../spec_helper"

module DatedBackup
  describe Version do
    it "should have the string equal to the current version" do
      DatedBackup::Version.string.should == "0.2.1"
    end
  end
end