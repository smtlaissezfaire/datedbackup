require File.dirname(__FILE__) + "/../../spec_helper"

describe DatedBackup, "loading from the binary" do
  before :each do
    @dsl = mock DatedBackup::DSL
    @filename = mock String
    @filename.stub!(:to_s).and_return @filename
  end
  
  # can't get this spec to work...
  # tried instance_evaling the load, although I suppose
  # that is futile, as the spec itself is already instance_eval'ed
  # by RSpec's code, hence the ARGV variable propagates into the
  # loaded binaries file environement (or rather the bin's file)
  # gets imported into *this* environement.  The real mystery
  # is why the stub on DSL.load doesn't carry over. 
  it "should call the DSL with the first file argument" #do
  #  DatedBackup::DSL.stub!(:load).and_return nil
  #  DatedBackup::DSL.load.should == nil
  #
  #  DatedBackup::DSL.should_receive(:load)
  #  ARGV[0] = @filename
  #  load File.dirname(__FILE__) + "/../../../bin/dbackup"      
  #end
end