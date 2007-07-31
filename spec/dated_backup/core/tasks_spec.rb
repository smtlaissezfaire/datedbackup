require File.dirname(__FILE__) + "/../../spec_helper"

module DatedBackup
  
  module CommonMock
    def include_common_mocks
      @kernel = mock Kernel
      @kernel.stub!(:puts).and_return @kernel
      @db = Core.new({}, @kernel)

      @db.stub!(:execute).and_return nil

      @a_string = mock String
      @a_string.stub!(:to_s).and_return @a_string
    end
  end

  describe Core, "- running tasks" do
    include CommonMock

    before :each do
      include_common_mocks

      @db.stub!(:create_main_backup_directory).and_return nil
      @db.stub!(:create_backup).and_return nil
    end

    it "should create the main backup directory" do
      @db.should_receive :create_main_backup_directory
      @db.run_tasks
    end

    it "should create the backup" do
      @db.should_receive :create_backup
      @db.run_tasks
    end
  end

  describe "a backup creation", :shared => true do
    it "should execute the rsync command for one directory" do
      @db.stub!(:sources).and_return [@a_string]

      @db.should_receive(:execute).with(@rsync_command, @kernel).once
      @db.create_backup
    end

    it "should execute the rsync command for many source directories" do
      @db.stub!(:sources).and_return [@a_string, @a_string]

      @db.should_receive(:execute).with(@rsync_command, @kernel).twice
      @db.create_backup
    end
  end

  describe Core, "- creating the backup with no other backups" do
    include CommonMock

    before :each do
      include_common_mocks

      @db.stub!(:options).and_return @a_string
      @db.stub!(:destination).and_return @a_string
      @db.stub!(:has_backup?).and_return false
      @rsync_command = "rsync -a --delete #{@db.options} #{@a_string} #{@db.destination}"
    end
    
    it_should_behave_like "a backup creation"
  end
  
  describe Core, "- creating the backup with other backups already present" do
    include CommonMock
    
    before :each do
      include_common_mocks
      
      @db.stub!(:options).and_return @a_string
      @db.stub!(:destination).and_return @a_string
      @db.stub!(:latest_backup).and_return @a_string
      @db.stub!(:has_backup?).and_return true
      @rsync_command = "rsync -a --delete --link-dest #{@db.latest_backup} #{@db.options} #{@a_string} #{@db.destination}"
    end
    
    it_should_behave_like "a backup creation"

  end

  describe Core, "- creating the main backup directory" do
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
  
  describe Core, "finding latest backup" do
    include CommonMock
    
    before :each do
      include_common_mocks
      @directories = [
        "2005-01-07-01h-01m-01s",
        "2006-01-07-01h-01m-01s",
        "2007-01-07-01h-01m-01s",
        "hello"
      ]
      @valid_directories = @directories.reject {|element| element == "hello"}
      @sorted_valid_directories = @valid_directories.sort
      
      Dir.stub!(:glob).and_return @directories
      @grep_regex = /[12][0-9]{3}\-[01][0-9]\-[0-3][0-9]\-[0-2][0-9]h\-[0-6][0-9]m\-[0-6][0-9]s/
      
      @db.stub!(:backup_root).and_return "backup_root"
    end
    
    it "should find the last backup directory" do
      Dir.should_receive(:glob).with("backup_root/*").and_return @directories
      @db.find_latest_backup
    end
    
    it "should grep the directories found for valid timestamps" do
      @directories.should_receive(:grep).with(@grep_regex).and_return @valid_directories
      @db.find_latest_backup
    end
    
    it "should sort the directories after the grep, reverse them, and then return the first one" do
      @db.find_latest_backup.should == @sorted_valid_directories.reverse.first
    end    
  end
  
  describe Core, "has_backup?" do
    include CommonMock
    
    before :each do
      include_common_mocks
      
      @dir = ["dir"]
      Dir.stub!(:glob).and_return @dir
    end
    
    it "should be true if a backup exists" do
      @dir.stub!(:grep).and_return ["2007-07-10-06h-01m-02s"]
      @db.has_backup?.should be_true
    end
    
    it "should should be false if a backup does not exist" do
      @dir.stub!(:grep).and_return []
      @db.has_backup?.should be_false
    end
  end
end

