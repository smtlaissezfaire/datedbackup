require File.dirname(__FILE__) + "/../spec_helper"

describe DatedBackup, "accessor methods" do
  it "should have source directory as array if only one provided" do
    DatedBackup.new("source" => "dir").sources.should == ["dir"]
  end
  
  it "should have source directories as array if many provided" do
    DatedBackup.new("sources" => ["dir1", "dir2"]).sources.should == ["dir1", "dir2"]
  end
  
  it "should assign the original destination as the backup_root" do
    DatedBackup.new("destination" => "dest").backup_root.should == "dest"
  end
  
  it "should have the options as a string" do
    DatedBackup.new("options" => "opt1, opt2").options.should == "opt1, opt2"
  end
  
  it "should have the destination as the destination dir/timestamp" do
    time = Time.now
    time_format = time.strftime "%Y-%m-%d-%Hh-%Mm-%Ss"
    
    DatedBackup.new("destination" => "dest").destination.should == "dest/#{time_format}"
  end
  
  it "should have the pre_run_commands as an array, if given many elements" do
    DatedBackup.new("pre_run_commands" => ["cmd1", "cmd2"]).pre_run_commands.should == ["cmd1", "cmd2"]
  end
  
  it "should have the pre_run_commands as an array if given one element" do
    DatedBackup.new("pre_run_command" => "cmd1").pre_run_commands.should == ["cmd1"]
  end
end

describe DatedBackup, "pre_run_commands" do
  before :each do
    @kernel = mock 'Kernel'
    @kernel.stub!(:`).and_return "execution output"
    @backup_dir = mock 'File'
  end
  
  it "should be called by the run command"
  it "should run the one command given before running the script"
end

describe DatedBackup, "errors" do
  before :each do
    @valid_hash = {
      "sources" => ["something"],
      "destination" => ["something"]
    }
  end
  
  it "should raise an error if not given a source directory" do
    h = @valid_hash.reject { |key, _| key == "sources" }
    lambda { DatedBackup.new(h).check_for_directory_errors }.should raise_error(DirectoryError, "No source directory given")
  end
  
  it "should raise an error if not given a destination directory" do
    h = @valid_hash.reject { |key, _| key == "destination"}
    lambda { DatedBackup.new(h).check_for_directory_errors }.should raise_error(DirectoryError, "No destination directory given")
  end
end

describe DatedBackup, "with invalid directories" do
  before :each do
    @kernel = mock 'Kernel'
  end
  
  it "should raise an error if the object was not given a directory" do
    backup = DatedBackup.new({"pre_run_command" => "cmd1"}, @kernel)
    lambda {backup.run}.should raise_error(DirectoryError)
  end
end