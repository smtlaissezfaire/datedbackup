require File.dirname(__FILE__) + "/../../spec_helper"

describe "DSL Integration/Regression Test with example.com Script" do
  before :each do
    @dbackup = mock DatedBackup::Core
    DatedBackup::Core.stub!(:new).and_return @dbackup
    @dbackup.stub!(:run).and_return @dbackup
    @dbackup.stub!(:set_attributes).and_return @dbackup
    @files = "example_scripts/example.com"
  end
  
  #user_domain  "nbackup@example.com"
  #options      "-v -e 'ssh -i /root/.ssh/rsync-key' --rsync-path='sudo rsync'"
  #sources      "/etc", "/home"
  #destination  "/var/backups/network/backups/example.com"
  
  it "should parse the key + value hash correctly" do
    @dbackup.should_receive(:set_attributes).with({
      :user_domain => ["nbackup@example.com"],
      :options     => ["-v -e 'ssh -i /root/.ssh/rsync-key' --rsync-path='sudo rsync'"],
      :sources     => ["/etc", "/home"],
      :destination => ["/var/backups/network/backups/example.com"]
    })
    DatedBackup::ExecutionContext.new :main, @files 
  end
end