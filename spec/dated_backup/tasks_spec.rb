require File.dirname(__FILE__) + "/../spec_helper"


  
describe DatedBackup::Tasks, "- running tasks" do
  before :each do
    @kernel = mock Kernel
    @db = DatedBackup.new @kernel
    
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

describe DatedBackup::Tasks, "- creating the backup" do
  it "should execute the rsync command for one directory"
  it "should execute the rsync command for many source directories" 
end

describe DatedBackup::Tasks, "- copying last backup to new backup" do
  it "should find the last backup's filename"
  it "should execute the copy command with the link option" 
end

describe DatedBackup::Tasks, "- creating the main backup directory" do
  it "should create the directory if it does not exist" 
  it "should not create the directory if the directory already exists" 
end
