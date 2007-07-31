require File.dirname(__FILE__) + "/../../spec_helper"

describe String, "to_time" do
  it "should create a valid time object from the string given" do
    "dir/2006-01-25-12h-00m-32s".to_time.should == Time.gm('2006', 01, 25, 12, 00, 32)
  end
end

module DatedBackup
  class Core
    describe BackupRemover, "removing directories" do
      before :each do
        @dir = mock Dir
        @rules = [{:constraint => :weekly}, {:constraint => :monthly}]
        
        @backup_set = mock BackupSet
        BackupSet.stub!(:find_files_in_directory).and_return @backup_set
        @backup_set.stub!(:filter_by_rule).and_return @backup_set
        @backup_set.stub!(:-).and_return @backup_set
        @backup_set.stub!(:map).and_return @backup_set
        @backup_set.stub!(:to_s).and_return "dir1 dir2"
        
        BackupRemover.stub!(:execute).and_return nil
        
        Kernel.stub!(:`).and_return nil
      end
      
      it "should collect the rules" do
        BackupRemover.remove!(@dir, @rules)
      end
            
      it "should create a new BackupSet from the directory given" do
        BackupSet.should_receive(:find_files_in_directory).with(@dir).and_return @backup_set
        BackupRemover.remove!(@dir, @rules)
      end
       
      it "should apply each rule in turn to successively eliminate the directories to keep" do
        @backup_set.should_receive(:filter_by_rule).twice.and_return @backup_set
        BackupRemover.remove!(@dir, @rules)
      end
            
      it "should collect the directories into a spaced string" do
        @backup_set.should_receive(:to_s).and_return "dir1 dir2"
        BackupRemover.remove!(@dir, @rules)
      end
      
      it "should remove the directories to be removed" do
        BackupRemover.should_receive(:execute).with("rm -rf dir1 dir2").and_return nil
        BackupRemover.remove!(@dir, @rules)
      end
            
    end
  end
end