require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

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