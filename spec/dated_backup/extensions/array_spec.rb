require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Array, "rest" do
  it "should return everything but the first element of the array" do
    [1,2,3].rest.should == [2,3]
  end
  
  it "should return nil if the list is empty" do
    [].rest.should == nil
  end
  
  it "should return an empty list if there is only one element in the list" do
    [1].rest.should == []
  end
end