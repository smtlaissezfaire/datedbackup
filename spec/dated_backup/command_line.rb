require File.dirname(__FILE__) + "/../spec_helper"

command_line = DatedBackup::CommandLine
include command_line

describe command_line, "execution" do
  
  before :each do
    @command = mock String
    @command_output = mock String
    
    @kernel_class = mock 'Kernel:Class'
    @kernel_class.stub!(:puts).and_return @kernel_class
    @kernel_class.stub!(:`).and_return @command_output
  end
  
  it "should execute the command given" do
    @kernel_class.should_receive(:`).with(@command).and_return @kernel_class
    execute(@command, @kernel_class)
  end
  
  it "should output run message" do
    @kernel_class.should_receive(:puts).with("* running: #{@command}").and_return @command_output
    execute(@command, @kernel_class)
  end
  
  it "should output the command output" do
    @kernel_class.should_receive(:puts).with(@command_output)
    execute(@command, @kernel_class)
  end
end