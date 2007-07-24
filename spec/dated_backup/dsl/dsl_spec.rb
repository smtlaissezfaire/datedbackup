require File.dirname(__FILE__) + "/../../spec_helper"

describe DatedBackup::DSL, "parsing" do
  before :each do
    @dsl = DatedBackup::DSL.new
  end
  
  it "should add the method given as a key if it is a valid keyword, with its paramaters" do
    @dsl.source "some_val"
    @dsl.hash.should == { :source => ["some_val"]}
  end
  
  it "should raise an InvalidKeyError if the method called is not a key" do
    lambda {
      @dsl.an_invalid_key
    }.should raise_error(InvalidKeyError, "The key 'an_invalid_key' is not a recognized expression")
  end
  
  it "should raise a friendly SyntaxError message when a syntax error is encountered"
  
end

describe DatedBackup::DSL, "load class method" do
  before :each do
    @dsl = mock DatedBackup::DSL
    @dsl.stub!(:load).and_return @dsl
    DatedBackup::DSL.stub!(:new).and_return @dsl
    @filename = mock String
  end
  
  it "should call new" do
    DatedBackup::DSL.should_receive(:new).with(no_args).and_return @dsl
    DatedBackup::DSL.load @filename
  end
  
  it "should call load with the filename" do
    @dsl.should_receive(:load).with(@filename).and_return @dsl
    DatedBackup::DSL.load @filename
  end 
end

describe DatedBackup::DSL, "loading from a file" do
  before :each do
    @db = mock DatedBackup
    DatedBackup.stub!(:new).and_return @db
    @db.stub!(:set_attributes).and_return nil
    @db.stub!(:run).and_return nil

    @dsl = DatedBackup::DSL.new

    @filename = mock String
    
    @file = mock 'File'
    @file.stub!(:read).and_return "source \"dir1\"
                                   destination \"dir2\""

    File.stub!(:open).and_yield @file
    @proc = Proc.new {}
  end
  
  it "should create a new DatedBackup object" do
    DatedBackup.should_receive(:new).and_return @db
    @dsl.load @filename
  end
  
  it "should create the DatedBackup object with the before and after procs" do
    @dsl.before &@proc
    @dsl.after &@proc
    
    DatedBackup.should_receive(:new).with({:before => @proc, :after => @proc}).and_return @db
    @dsl.load @filename
  end
  
  it "should assign the appropriate hash after loading the file" do
    @dsl.load @filename
    @dsl.hash.should == {
      :source => ['dir1'],
      :destination => ['dir2']
    }
  end
  
  it "should set the attributes on the DatedBackup instance" do
    @db.should_receive(:set_attributes).with( 
    {
      :source => ['dir1'],
      :destination => ['dir2']
    }).and_return nil
    @dsl.load @filename
  end
  
  it "should call run after the attributes have been set on the dated backup instance" do
    @db.should_receive(:run).with(no_args).and_return nil
    @dsl.load @filename
  end
  
  it "should be able to use a single quoted value" do
    @dsl.instance_eval "source 'a single quoted value'"
    @dsl.hash.should == {
      :source => ['a single quoted value']
    }
  end
  
  it "should be able to use a double quoted value" do
    @dsl.instance_eval "source \"a single quoted value\""
    @dsl.hash.should == {
      :source => ["a single quoted value"]
    }
  end
end

describe DatedBackup::DSL, "pre and post run scripts" do
  before :each do
    @dsl = DatedBackup::DSL.new
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

