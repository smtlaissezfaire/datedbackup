require File.dirname(__FILE__) + "/../../spec_helper"

module DatedBackup
  class Core
    
    describe BackupSet, "filtering by :constraint" do
      before :each do
        @data = [
          "dir/2006-01-25-12h-00m-32s",
          "dir/2007-07-03-12h-00m-01s",
          "dir/2007-07-04-01h-22m-38s"
        ]
        @set = BackupSet.new(@data)
        @now = Time.gm('2007','07','05')
      end

      it "should return the elements in this year" do
        @set.filter_by_rule(:constraint => @now.at_beginning_of_year...@now).should == 
          BackupSet.new(["dir/2007-07-03-12h-00m-01s", "dir/2007-07-04-01h-22m-38s"])
      end

      it "should return the elements from last year" do
        @set.filter_by_rule(:constraint => @now.last_year.at_beginning_of_year..@now.last_year.end_of_year).should ==
          BackupSet.new(["dir/2006-01-25-12h-00m-32s"])
      end
    end

    describe BackupSet, "filtering by :scope => :yearly" do
      before :each do
        @data = [
          "dir/2006-01-25-12h-00m-32s",
          "dir/2007-07-03-12h-00m-01s",
          "dir/2007-07-04-01h-22m-38s"    
        ]
        @set = BackupSet.new(@data)
      end

      it "should find one from this year and last year" do
        @set.filter_by_rule(:scope => :yearly).should == BackupSet.new([
          "dir/2006-01-25-12h-00m-32s",
          "dir/2007-07-04-01h-22m-38s" 
        ])
      end
    end

    describe BackupSet, "filtering by :scope => :monthly" do

      before :each do
        @data = [
          "dir/2007-01-25-12h-00m-32s",
          "dir/2007-07-03-12h-00m-01s",
          "dir/2007-07-04-01h-22m-38s"    
        ]
        @set = BackupSet.new(@data)
      end


      it "should find one from each month" do
        @set.filter_by_rule(:scope => :monthly).should == BackupSet.new([
          "dir/2007-07-04-01h-22m-38s",
          "dir/2007-01-25-12h-00m-32s"
        ])
      end
    end

    describe BackupSet, "filtering by :scope => :weekly" do
      before :each do
        @data = [
          "dir/2007-06-30-12h-00m-32s", # Saturday - week 1
          "dir/2007-07-01-12h-00m-01s", # Sunday   - week 1
          "dir/2007-07-02-01h-22m-38s", # Moday    - week 2
          "dir/2007-07-03-01h-22m-38s"  # Tuesday  - week 2
        ]
        @set = BackupSet.new(@data)
      end

      it "should find one from each week" do
        @set.filter_by_rule(:scope => :weekly).should == BackupSet.new([
          "dir/2007-07-01-12h-00m-01s", # Sunday   - week 1
          "dir/2007-07-03-01h-22m-38s"  # Tuesday  - week 2
        ])
      end
    end

    describe BackupSet, "filtering by :scope => :daily" do
      before :each do
        @data = [
          "dir/2007-06-30-12h-00m-01s",
          "dir/2007-07-01-12h-00m-01s", 
          "dir/2007-07-01-19h-00m-01s", 
          "dir/2007-07-02-01h-22m-38s", 
          "dir/2007-07-02-19h-22m-38s"  
        ]
        @set = BackupSet.new(@data)
      end

      it "should find one per day" do
        @set.filter_by_rule(:scope => :daily).should == BackupSet.new([
          "dir/2007-06-30-12h-00m-01s",
          "dir/2007-07-01-19h-00m-01s",  
          "dir/2007-07-02-19h-22m-38s"  
        ])
      end
    end

    describe BackupSet, "filtering by :scope => :weekly with :constraint => this month's time range" do
      before :each do
        @now = Time.gm '2007', '07', '12'
        @data = [
          "dir/2007-06-30-12h-00m-01s",
          "dir/2007-07-01-12h-00m-01s", # week 1
          "dir/2007-07-02-12h-00m-01s", # week 2
          "dir/2007-07-03-19h-00m-01s", 
          "dir/2007-07-08-01h-22m-38s", 
          "dir/2007-07-09-19h-22m-38s"  # week 3 - week begins on this day
        ]
        @set = BackupSet.new(@data)
      end

      it "should find one per week in the constraint" do
        @set.filter_by_rule(:scope => :weekly, :constraint => @now.beginning_of_month...@now.end_of_month).should == [
          "dir/2007-07-09-19h-22m-38s",  
          "dir/2007-07-08-01h-22m-38s", 
          "dir/2007-07-01-12h-00m-01s" 
        ]
      end
    end  
    
    describe BackupSet, "find_files_in_directory" do
      before :each do
        @dir = mock String
        @dir.stub!(:to_s).and_return "dir"
        
        Dir.stub!(:glob).and_return ["dir1", "dir2"]
        @backup_set = mock BackupSet
        BackupSet.stub!(:new).and_return @backup_set
        
        File.stub!(:directory?).and_return true
      end
      
      it "should take a directory" do
        BackupSet.find_files_in_directory @dir
      end
      
      it "should raise an error if not given a valid directory" do
        File.stub!(:directory?).and_return false
        lambda { BackupSet.find_files_in_directory(@dir) }.should raise_error(InvalidDirectoryError, "A valid directory must be given.")
      end
      
      it "should find all of the files in that directory which have a timestamp" do
        Dir.should_receive(:glob).with("#{@dir}/*").and_return ["dir1", "dir2"]
        BackupSet.find_files_in_directory @dir
      end
      
      it "should not find the files in a directory which do not correspond to a timestamp" 
      
      it "should call new with the files found" do
        BackupSet.should_receive(:new).with(["dir1", "dir2"]).and_return @backup_set
        BackupSet.find_files_in_directory @dir
      end
    end
    
    describe BackupSet, "subtracting two BackupSets (regression test)" do
      before :each do
        @a = BackupSet.new []
        @b = BackupSet.new []
      end
      
      it "should return a new BackupSet" do
        (@a - @b).kind_of?(BackupSet).should be_true
      end
    end
    
  end  
end

