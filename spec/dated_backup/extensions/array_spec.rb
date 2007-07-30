require File.dirname(__FILE__) + "/../../spec_helper"

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
  
  it "should hold a unique array even after a method which changes the state of the array"
  it "should hold a reverse-sorted unique array even after a method has changed the state of the array" 
end

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