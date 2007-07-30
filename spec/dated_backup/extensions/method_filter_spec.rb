require File.dirname(__FILE__) + "/../../spec_helper"

class ExampleTestClass < Array
  
  def some_method
    "hello, world"
  end

  include MethodDispatcher
  extend  MethodFilter
  
  add_filters
  
  def before_all
    some_method
  end

  
  
end


describe "MethodFilter" do
  before :each do
    @a = ExampleTestClass.new
  end
  
  it "should have the dispatcher method which returns the scoped MethodDispatcher class" do
    @a.dispatcher.should == ExampleTestClass::MethodDispatcher
  end
  
  it "should execute the before method before a method call" do
    @a.stub!(:before_all).and_return nil
    @a.should_receive(:before_all)
    @a.some_method
  end
  
  it "should execute the after method after the method call" 
  
  it "should not call a method recursively" do
    @a.some_method
  end
end

#describe "MethodFilter::MethodDispatcher" do
#  before :each do
#    @a = ExampleTestClass.new
#    @dispatcher = @a.dispatcher
#    @um = ExampleTestClass.instance_method :some_method
#  end
#  
#  it "should have the method after adding it to the array" do
#    @dispatcher.add_method @um
#    @dispatcher.has_method?(:some_method).should be_true
#  end
#  
#  it "should have no methods if no methods have been added" do
#    @dispatcher.has_method?(:some_method).should be_true
#  end
#  
#  it "should be able to call the method with the obj to execute in, the name of the method (as a symbol), with it's arguments and a block" do
#    @dispatcher.add_method @um
#    # stubbing + should_receive won't work here, because the unbound method call is still using the old
#    # method, not the method which is stubbed
#    #@a.stub!(:some_method).and_return "hello, world"
#    #@a.should_receive(:some_method).and_return nil
#    (@dispatcher.call_method :some_method, @a).should == "hello, world"
#  end
#end