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

describe "DSL Integration/Regression Test with the local_etc_backup script" do
  before :each do
    @dbackup = mock DatedBackup::Core
    DatedBackup::Core.stub!(:new).and_return @dbackup
    @dbackup.stub!(:run).and_return @dbackup
    @dbackup.stub!(:set_attributes).and_return @dbackup
    @file = "example_scripts/local_etc_backup"
  end

  #source       '/etc'
  #destination  '/root/etc_backup'
  #
  #after {
  #  remove_old {
  #    keep this weeks backups
  #    keep monthly backups    
  #  }
  #}
  
  it "should parse the key + value hash correctly" do
    @dbackup.should_receive(:set_attributes).with({
      :source => ["/etc"],
      :destination => ["/root/etc_backup"]
    })
    DatedBackup::ExecutionContext.new :main, @file
  end
end

describe "DSL Integration/Regression Test with the local_etc_backup script with a block" do
  before :each do
    t = Time.gm '2007', '07', '31'
    @directories = [
      "2007-07-31-00h-00m-00s", #tuesday
      "2007-07-30-00h-00m-00s",
      "2007-07-27-00h-00m-00s", # last week
      "2007-06-31-00h-00m-00s",
      "2007-06-30-00h-00m-00s",
      "2007-05-31-00h-00m-00s"
    ]
    
    @after_run = lambda {
      remove_old {
        keep this weeks backups
        keep monthly backups
      }
    }
    Kernel.stub!(:`).and_return nil
  end
  
  
  it "should send rm -rf to all of the directories which are not kept" #do
  #  require 'rubygems'; require 'ruby-debug'; debugger;
  #  Kernel.should_receive(:`).with("rm -rf dest/2007-06-31-00h-00m-00s dest/2007-05-31-00h-00m-00s")
  #  DatedBackup::ExecutionContext.new :before, &@after_run
  #end
end

describe "DSL Integration/Regression Tests with the samba_shares script" do
  before :each do
    @dbackup = mock DatedBackup::Core
    DatedBackup::Core.stub!(:new).and_return @dbackup
    @dbackup.stub!(:run).and_return @dbackup
    @dbackup.stub!(:set_attributes).and_return @dbackup
    @file = "example_scripts/samba_shares"
  end

  # source      = '/mnt/shares'
  # destination = '/var/backups/network/backups/shares'
  # options     = '-v' 
  # 
  # after do
  # 
  #   # CAREFUL! This will remove all old backups
  #   # except the ones specified inside the block by the 'keep' rules
  #   remove_old do
  #     keep this weeks backups 
  #     keep last weeks backups 
  #     keep weekly backups from this month # or: keep this months weekly backups
  #     keep monthly backups # or: keep all monthly backups
  #   end
  # 
  # end
  
  it "should parse the key + value hash correctly" do
    @dbackup.should_receive(:set_attributes).with({
      :source => ["/mnt/shares"],
      :destination => ["/var/backups/network/backups/shares"],
      :options => ["-v"]
    })
    DatedBackup::ExecutionContext.new :main, @file
  end
end
