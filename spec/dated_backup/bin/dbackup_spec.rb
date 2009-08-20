require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe DatedBackup, "loading from the binary" do
  before :each do
    @evaluation_object = Object.new
    @evaluation_object.stub!(:require).and_return nil
    DatedBackup::ExecutionContext.stub!(:new).and_return nil
    @filename = "some_config"
    
    @old_argv = ARGV
    @new_argv = [@filename]
    ARGV = @new_argv
  end
  
  after :each do
    ARGV = @old_argv
  end
  
  it "should call the ExecutionContext with the main DSL and the first file argument" do
    DatedBackup::ExecutionContext.should_receive(:new).with(:main, @filename).and_return nil
    @evaluation_object.instance_eval File.read("bin/dbackup")
  end

end