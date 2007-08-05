require File.dirname(__FILE__) + "/../../spec_helper"

describe "DSL Integration/Regression Test with example.com Script" do
  before :each do
    @dbackup = mock DatedBackup::Core
    DatedBackup::Core.stub!(:new).and_return @dbackup
    @dbackup.stub!(:run).and_return @dbackup
    @dbackup.stub!(:set_attributes).and_return @dbackup
    @files = "example_configs/example.com"
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
    @file = "example_configs/local_etc_backup"
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

describe "DSL Integration/Regression Tests with the samba_shares script" do
  before :each do
    @dbackup = mock DatedBackup::Core
    DatedBackup::Core.stub!(:new).and_return @dbackup
    @dbackup.stub!(:run).and_return @dbackup
    @dbackup.stub!(:set_attributes).and_return @dbackup
    @file = "example_configs/samba_shares"
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

describe "Full Stack Regression Test with the samba_shares script when the month has rolled over for August 2007" do
  
  before :each do
    @now = Time.gm('2007', '08', '01')
    @last_month = @now.last_month.at_beginning_of_month

    @directories = DatedBackup::Core::BackupSet.new []
    @last_month.each_day_in_month do |time|
      @directories << "/var/backups/network/backups/shares/#{time.to_string}"
    end
    @directories << "/var/backups/network/backups/shares/#{@now.to_string}"
    
  end
  
  it "should remove the directories from the first two weeks of July 2007" 
end
