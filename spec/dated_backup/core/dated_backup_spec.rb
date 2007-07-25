require File.dirname(__FILE__) + "/../../spec_helper"

describe DatedBackup, "accessor methods" do
  before :each do
    @kernel = mock 'Kernel'
    @db = DatedBackup.new({}, @kernel)
  end
  
  it "should have source directory as array if only one provided" do
    @db.set_attributes :source => "dir"
    @db.sources.should == ["dir"]
  end
  
  it "should have source directories as array if many provided" do
    @db.set_attributes :sources => ["dir1", "dir2"]
    @db.sources.should == ["dir1", "dir2"]
  end
  
  it "should assign the original destination as the backup_root" do
    @db.set_attributes :destination => "dest"
    @db.backup_root.should == "dest"
  end
  
  it "should have the options as a string" do
    @db.set_attributes :options => "opt1, opt2"
    @db.options.should == "opt1, opt2"
  end
  
  it "should have the destination as the destination dir/timestamp" do
    time = Time.now
    time_format = time.strftime "%Y-%m-%d-%Hh-%Mm-%Ss"
    
    @db.set_attributes :destination => "dest"
    @db.destination.should == "dest/#{time_format}"
  end
  
  it "should have the pre_run_commands as an array, if given many elements" do
    @db.set_attributes :pre_run_commands => ["cmd1", "cmd2"]
    @db.pre_run_commands.should == ["cmd1", "cmd2"]
  end
  
  it "should have the pre_run_commands as an array if given one element" do
    @db.set_attributes :pre_run_command => "cmd1"
    @db.pre_run_commands.should == ["cmd1"]
  end
  
  it "should have the user and domain" do
    @db.set_attributes :user_domain => "scott@railsnewbie.com"
    @db.user_domain.should == "scott@railsnewbie.com"
  end
  
  it "should have the user and domain prepended upon each source" do
    @db.set_attributes :user_domain => "scott@railsnewbie.com", :sources => ["dir1", "dir2"]
    @db.sources.should == ["scott@railsnewbie.com:dir1", "scott@railsnewbie.com:dir2"]
  end
end

describe DatedBackup, "pre and post run" do
  before :each do
    @kernel = mock 'Kernel'
    @kernel.stub!(:`).and_return "execution output"

    @backup_dir = mock 'File'

    @obj = mock Object

    @proc = mock Proc
    @proc.stub!(:call).and_return @obj
  end
  
  it "should initialize the DatedBackup class with a before hash which contains a proc object" do
    db = DatedBackup.new({:before => @proc}, @kernel)
    db.before_run.should == @proc
  end
  
  it "should initialize the DatedBackup class with an after hash which contains a proc object" do
    db = DatedBackup.new({:after => @proc}, @kernel)
    db.after_run.should == @proc
  end
  
  it "should initialize the DatedBackup class with an empty before procedure even if no before key is given" do
    Proc.stub!(:new).and_return @proc
    Proc.should_receive(:new).and_return @proc
    db = DatedBackup.new({:after => "blah blah" }, @kernel)
    db.before_run.should == @proc
  end
  
  it "should initialize the DatedBackup class with an empty after procedure even if no after key is given" do
    Proc.stub!(:new).and_return @proc
    Proc.should_receive(:new).and_return @proc
    db = DatedBackup.new({:before => "blah blah"}, @kernel)
    db.after_run.should == @proc
  end
  
  #it "should execute the block given in the pre run before the real running" do
  #  db = DatedBackup.new({:before => @proc}, @kernel)
  #  db.stub!(:check_for_directory_errors).and_return nil
  #  db.stub!(:run_tasks).and_return nil
  #  @proc.should_receive(:call).and_return @obj
  #  db.run
  #end
  #
  #it "should execute the block given in the post run after the real running" do
  #  db = DatedBackup.new({:after => @proc}, @kernel)
  #  db.stub!(:check_for_directory_errors).and_return nil
  #  db.stub!(:run_tasks).and_return nil
  #  @proc.should_receive(:call).and_return @obj
  #  db.run
  #end
end

describe DatedBackup, "running" do
  before :each do
    @kernel = mock 'Kernel'
    @db = DatedBackup.new({}, @kernel)
    @db.stub!(:check_for_directory_errors).and_return nil
    @db.stub!(:run_tasks).and_return nil
  end
  
  it "should check for directory errors" do
    @db.should_receive(:check_for_directory_errors).with no_args
    @db.run
  end
  
  it "should call the run_tasks method" do
    @db.should_receive(:run_tasks).with no_args
    @db.run
  end
end

describe DatedBackup, "errors" do
  before :each do
    @valid_hash = {
      :sources => ["something"],
      :destination => ["something"]
    }
    @kernel = mock 'Kernel'
    @db = DatedBackup.new({}, @kernel)
  end
  
  it "should raise an error if not given a source directory" do
    h = @valid_hash.reject { |key, _| key == :sources }
    @db.set_attributes h

    lambda { 
      @db.check_for_directory_errors 
    }.should raise_error(DirectoryError, "No source directory given")
  end
  
  it "should raise an error if not given a destination directory" do
    h = @valid_hash.reject { |key, _| key == :destination }
    @db.set_attributes h
    
    lambda { 
      @db.check_for_directory_errors 
    }.should raise_error(DirectoryError, "No destination directory given")
  end
end

describe DatedBackup, "with invalid directories" do
  before :each do
    @kernel = mock 'Kernel'
    @db = DatedBackup.new({}, @kernel)
  end
  
  it "should raise an error if the object was not given a directory" do
    @db.set_attributes :pre_run_command => "cmd1"
    lambda {
      @db.run
    }.should raise_error(DirectoryError)
  end
end

