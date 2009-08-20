require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module DatedBackup
  describe Version do
    it "should have the string equal to the current version" do
      DatedBackup::Version.to_s.should == "0.2.1"
    end
  end
end