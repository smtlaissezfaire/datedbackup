require File.dirname(__FILE__) + "/../../spec_helper"

describe UnboundMethod, "extensions" do
  before :each do
    @unbound_method = Array.instance_method :sort!
  end
  
  it "should have the method name of the unbound method" do
    @unbound_method.method_name.should == :sort!
  end
  
  it "should have the class name of the unbound method" do
    @unbound_method.class_name.should == Array
  end
  
  it "should have the name of the class or Module where the method was defined" do
    @unbound_method.defined_in.should == Array
  end
end