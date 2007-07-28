require File.dirname(__FILE__) + "/../../spec_helper"

describe String, "to_time" do
  it "should create a valid time object from the string given" do
    "dir/2006-01-25-12h-00m-32s".to_time.should == Time.gm('2006', 01, 25, 12, 00, 32)
  end
end

module DatedBackup
  class Core
    
    describe BackupRemover, "building directories" do
      before :each do
        @directory = "dir"
        @subdirectories = [
          "dir/2006-01-25-12h-00m-32s",
          "dir/2007-06-05-22h-32m-02s",
          "dir/2007-07-02-18h-54m-01s",
          "dir/2007-07-03-12h-00m-01s",
          "dir/2007-07-04-12h-00m-02s",
          "dir/2007-07-05-12h-00m-01s",
          "dir/2007-07-10-22h-35m-21s",
          "dir/2007-07-19-12h-00m-03s",
          "dir/2007-07-20-12h-00m-33s",
          "dir/2007-07-21-12h-00m-33s",
          "dir/2007-07-22-12h-01m-02s",
          "dir/2007-07-23-12h-00m-15s",
          "dir/2007-07-24-12h-00m-34s",
        ]
        Dir.stub!(:glob).and_return @subdirectories
        @remover = BackupRemover.new(@directory)
      end
      
      #it "should find all of the dated subdirectories present in the directory given" do
      #  Dir.should_receive(:glob).with("#{@directory}/*").and_return @subdirectories
      #  @remover.build_directories([])
      #end
      #
      #it "should use a time constraint to filter out directories to keep" do
      #  @remover.build_directories [{:constraint => Time.now.at_beginning_of_year...Time.now}]
      #  @remover.to_keep.should == (@subdirectories - [@subdirectories.first]).to_set
      #end
      #it "should use the keep_array's first element with a constraint to filter out wanted directories" do
      #  keep_array = [{:constraint => Time.now.beginning_of_year...Time.now}]
      #  @remover.remove!(keep_array)        
      #  
      #  @remover.to_remove.should == 
      #  @remover.to_keep.should == @subdirectories - @subdirectories.first
      #end
      
      #it "should use the keep_array's first element with a :yearly scope to filter out wanted directories" do
      #  keep_array = [{:scope => :yearly}]
      #  @remover.remove!(keep_array)
      #  
      #  @remover.to_remove.should == TimeArray.new([
      #    "dir/2006-01-25-12h-00m-32s",
      #    "dir/2007-06-05-22h-32m-02s"
      #  ])
      #end
      
      it "should use the keep_array's first element with a scope and constraint to filter out wanted directories" do
        
      end
      
      it "should use the keey_array's second element to filter out unwanted directories" 
      it "should remove the directories left after the keep_array directories have been filtered" 
    end
  end
end