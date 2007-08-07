require File.dirname(__FILE__) + "/../../spec_helper"

describe AnonymousClass do
  before(:each) do
    @class = mock Class
    Class.stub!(:new).and_return @class
    @class.stub!(:some_method).and_return nil
    
    @mock_module = mock Module
  end
  
  it "should initialize a brand new class" do
    AnonymousClass.new.class.should == @class
  end
  
  it "should have the new anonymous class accessible as both class and klass" do
    AnonymousClass.new.class.should == AnonymousClass.new.klass
  end
  
  it "should evaluate the block given to AnonymousClass.new and evaluate the anonymous class in the block" do
    @class.should_receive(:some_method).and_return nil
    AnonymousClass.new do
      some_method
    end
  end
  
  it "should have new method which creates a new instance of the anonymous class" do
    @class.should_receive(:new)
    AnonymousClass.new.new
  end
  
  it "should have the include method" do
    AnonymousClass.new.should respond_to(:include)
  end
  
  it "should be able to include one module into the anonymous class" do
    @class.should_receive(:include).with(Enumerable)
    AnonymousClass.new.include(Enumerable)
  end
  
  it "should be able to include multiple modules into the anonymous class" do
    @class.should_receive(:include).with(Enumerable)
    @class.should_receive(:include).with(@mock_module)
    AnonymousClass.new.include(Enumerable, @mock_module)
  end
  
  it "should be able to open up the class and evaluate inside it" do
    @class.should_receive(:some_method)
    ac = AnonymousClass.new
    ac.evaluate do
      some_method
    end
  end
  
  it "should be able to send the class an arbitrary method" do
    @class.should_receive(:some_method)
    ac = AnonymousClass.new
    ac.send(:some_method)
  end
end