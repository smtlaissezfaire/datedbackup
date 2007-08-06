require File.dirname(__FILE__) + "/../../spec_helper"

describe Array, "car" do
  it "should return the first element of the array" do
    [1,2,3].car.should == 1
  end
end

describe Array, "cdr" do
  it "should return everything but the first element of the array" do
    [1,2,3].cdr.should == [2,3]
  end
  
  it "should return nil if the list is empty" do
    [].cdr.should == nil
  end
  
  it "should return an empty list if there is only one element in the list" do
    [1].cdr.should == []
  end
end

describe Array, "to_backup_set" do
  it "should return a new BackupSet item, sorted, reversed, and with unique values" do
    [1,3,2,3,3,3,2].to_backup_set.should == DatedBackup::Core::BackupSet.new([3,2,1])
  end
end