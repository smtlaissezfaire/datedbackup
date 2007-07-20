require File.dirname(__FILE__) + "/../spec_helper"

module CommonMock
  def include_common_mocks
    @kernel = mock Kernel
    @kernel.stub!(:puts).and_return @kernel
    @db = DatedBackup.new @kernel
    
    @db.stub!(:execute).and_return nil
    
    @a_string = mock String
    @a_string.stub!(:to_s).and_return @a_string
  end
end
  
describe DatedBackup, "- running tasks" do
  include CommonMock
  
  before :each do
    include_common_mocks
    
    @db.stub!(:create_main_backup_directory).and_return nil
    @db.stub!(:cp_last_backup_to_new_backup).and_return nil
    @db.stub!(:create_backup).and_return nil
  end
  
  it "should create the main backup directory" do
    @db.should_receive :create_main_backup_directory
    @db.run_tasks
  end
  
  it "should copy the last backup to the new backup" do
    @db.should_receive :cp_last_backup_to_new_backup
    @db.run_tasks
  end
  
  it "should create the backup" do
    @db.should_receive :create_backup
    @db.run_tasks
  end
end

describe DatedBackup, "- creating the backup" do
  include CommonMock
  
  before :each do
    include_common_mocks
    
    @db.stub!(:options).and_return @a_string
    @db.stub!(:destination).and_return @a_string
  end
  
  it "should execute the rsync command for one directory" do
    @db.stub!(:sources).and_return [@a_string]

    @db.should_receive(:execute).with("rsync -a --delete #{@db.options} #{@a_string} #{@db.destination}", @kernel).once
    @db.create_backup
  end
  
  it "should execute the rsync command for many source directories" do
    @db.stub!(:sources).and_return [@a_string, @a_string]
    
    @db.should_receive(:execute).with("rsync -a --delete #{@db.options} #{@a_string} #{@db.destination}", @kernel).twice
    @db.create_backup
  end
end

describe DatedBackup, "- copying last backup to new backup" do
  include CommonMock
  
  before :each do
    include_common_mocks
    @db.stub!(:find_last_backup_filename).and_return @a_string
    @db.stub!(:destination).and_return @a_string
  end
  
  it "should find the last backup's filename" do
    @db.should_receive(:find_last_backup_filename).and_return @a_string
    @db.cp_last_backup_to_new_backup
  end
  it "should execute the copy command with the link option" do
    @db.should_receive(:execute).with("cp -al #{@db.find_last_backup_filename} #{@db.destination}", @kernel)
    @db.cp_last_backup_to_new_backup
  end
end

describe DatedBackup, "- creating the main backup directory" do
  include CommonMock
  
  before :each do
    include_common_mocks
    @db.stub!(:backup_root).and_return @a_string
    Dir.stub!(:mkdir).and_return true
  end
  
  it "should create the directory if it does not exist" do
    File.stub!(:exists?).and_return false
    Dir.should_receive(:mkdir).with @db.backup_root
    @db.create_main_backup_directory
  end
  
  it "should give a message that the directory is being created if the directory does not exist" do
    File.stub!(:exists?).and_return false
    @kernel.should_receive(:puts).with "* Creating main backup directory #{@db.backup_root}"
    @db.create_main_backup_directory
  end
  
  it "should not create the directory if the directory already exists" do
    File.stub!(:exists?).and_return true
    Dir.should_not_receive(:mkdir)
    @db.create_main_backup_directory
  end
end
