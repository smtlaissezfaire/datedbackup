require File.dirname(__FILE__) + "/../spec_helper"

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
  end
  
  it "should create a new DatedBackup object" do
    DatedBackup.should_receive(:new).with(no_args).and_return @db
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