require File.dirname(__FILE__) + "/../../spec_helper"

class MainExecutionContext
  include DatedBackup::DSL::Main
end

describe MainExecutionContext, "parsing" do
  before :each do
    @dsl = MainExecutionContext.new
  end
  
  it "should add the method given as a key if it is a valid keyword, with its paramaters" do
    @dsl.source = "some_val"
    @dsl.hash.should == { :source => ["some_val"]}
  end
  
  it "should raise an InvalidKeyError if the method called is not a key" do
    lambda {
      @dsl.an_invalid_key = "something"
    }.should raise_error(InvalidKeyError, "The key 'an_invalid_key' is not a recognized expression")
  end
  
  it "should raise a friendly SyntaxError message when a syntax error is encountered"
  
end

describe MainExecutionContext, "pre and post run scripts" do
  before :each do
    @dsl = MainExecutionContext.new
    @proc = Proc.new {}
  end
  
  it "should have the before method" do
    @dsl.should respond_to(:before)
  end
  
  it "should have the after method" do
    @dsl.should respond_to(:after)
  end
  
  it "should raise an error if no block is given to the before method" do
    lambda { @dsl.before }.should raise_error(NoBlockGiven, "A block (do...end) must be given")
  end
  
  it "should raise an error if no block is given to the after method" do
    lambda { @dsl.after }.should raise_error(NoBlockGiven,  "A block (do...end) must be given")
  end
  
  it "should make the before proc a class readable entity" do
    @dsl.before &@proc
    @dsl.procs.should == {:before => @proc}
  end
  
  it "should make the proc passed to after readable by the class" do
    @dsl.after &@proc
    @dsl.procs.should == {:after => @proc}
  end
  
  it "should be able to use both before and after as the procs, with appropriate proc keys" do
    @dsl.before &@proc
    @second_proc = Proc.new {}
    @dsl.after &@second_proc
    @dsl.procs.should == {:before => @proc, :after => @second_proc}
  end
end

