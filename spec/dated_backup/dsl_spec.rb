
require File.dirname(__FILE__) + "/../spec_helper"

dsl = DatedBackup::DSL
config = File.dirname(__FILE__) + "/../example_scripts/example.com.new_syntax"

describe dsl do
  before :each do
    @mock = mock 'DatedBackup'
    @mock.stub!(:new).and_return @mock
    @mock.stub!(:run).and_return @mock
    
    @dsl = dsl.new(@mock)
  end
  
  it "should parse one key" do
    @dsl.parse("var = attribute")
    @dsl.data_hash.should == {:var => ["attribute"]}
  end
  
  it "should parse a multi-value key as an array" do
    @dsl.parse("var = value1, value2")
    @dsl.data_hash.should == {:var => ["value1", "value2"]}
  end
  
  it "should parse a multi-value key over mutliple lines" do
    @dsl.parse("var = value1,\n value2")
    @dsl.data_hash.should == {:var => ["value1", "value2"]}
  end
  
  it "should parse a multi-value key over multiple lines with any number of spaces" do
    @dsl.parse "var = value1,\n          value2"
    @dsl.data_hash.should == {:var => ["value1", "value2"]}
  end
  
  it "should parse a newline as \n or \r\n" do
    @dsl.parse "var = value1,\r\nvalue2"
    @dsl.data_hash.should == {:var => ["value1", "value2"]}
  end
  
  it "should be able to handle multiple key value pairs" do
    @dsl.parse "var = value1\n var2 = value2, value3\n var3 = value7, \nvalue 18, \nvalue19"
    @dsl.data_hash.should == {
      :var => ["value1"],
      :var2 => ["value2", "value3"],
      :var3 => ["value7", "value 18", "value19"]
    }
  end
  
  it "should raise a ParseError w/ invalid data" 
  
  it "should have convenience method run which calls new.parse"
  
  it "should run the script" do
    @dsl.parse "var = var1"
    @mock.should_receive(:new).with(:var => ["var1"]).and_return @mock
    @mock.should_receive(:run).with(no_args).and_return @mock
    @dsl.run
  end
end