require File.dirname(__FILE__) + "/../../spec_helper"

module DatedBackup
  class Core
    describe CommandLine, "execution" do
      

      before :each do
        @obj = Class.new do
          include CommandLine
        end.new
        
        @command = mock String
        @command_output = mock String

        @kernel_class = mock 'Kernel:Class'
        @kernel_class.stub!(:puts).and_return @kernel_class
        @kernel_class.stub!(:`).and_return @command_output
      end
      
      it "should execute the command given" do
        @kernel_class.should_receive(:`).with(@command).and_return @kernel_class
        @obj.execute(@command, @kernel_class)
      end

      it "should output run message" do
        @kernel_class.should_receive(:puts).with("* running: #{@command}").and_return @command_output
        @obj.execute(@command, @kernel_class)
      end

      it "should output the command output" do
        @kernel_class.should_receive(:puts).with(@command_output)
        @obj.execute(@command, @kernel_class)
      end
    end    
  end
end

