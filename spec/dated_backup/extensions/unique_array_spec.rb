require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe ReverseSortedUniqueArray do
  it "should hold a unique array after initialization" do
    ReverseSortedUniqueArray.new([1,2,3,1]).should == [3,2,1]
  end
  
  it "should hold a reverse-sorted array after initialization" do
    ReverseSortedUniqueArray.new([2,1,4,7,1,1]).should == [7,4,2,1]
  end
  
  it "should be of class ReverseSortedUniqueArray" do
    ReverseSortedUniqueArray.new().class.should == ReverseSortedUniqueArray
  end
  
  it "should hold a unique array even after a method has changed the state of the array"
  it "should hold a reverse-sorted unique array even after a method has changed the state of the array" 
end