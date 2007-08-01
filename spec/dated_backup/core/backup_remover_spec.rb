require File.dirname(__FILE__) + "/../../spec_helper"

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
      
      it "should not issue the rm command if no directories are to be removed"
    end
    
    describe BackupRemover, "removing directories (regression tests)" do
      before :each do
        @complete_set = BackupSet.new [
          "/root/etc_backup/2007-08-01-16h-36m-47s", 
          "/root/etc_backup/2007-08-01-16h-28m-59s", 
          "/root/etc_backup/2007-07-31-07h-16m-15s",
          "/root/etc_backup/2007-07-20-16h-27m-03s", ]
        @backup_root = "/root/etc_backup"
        @keep_rules = [{
          :scope=>:monthly, 
          :constraint=>Time.gm('1969', '12', '31', '19')...Time.gm('2007', '08', '01', '16', '37', '10')
        }]
        BackupSet.stub!(:find_files_in_directory).and_return @complete_set
        Core::BackupRemover.stub!(:execute).and_return nil
      end
      
      it "should remove the directories" do
        Core::BackupRemover.should_receive(:execute).with("rm -rf /root/etc_backup/2007-08-01-16h-28m-59s /root/etc_backup/2007-07-20-16h-27m-03s")
        Core::BackupRemover.remove!(@backup_root, @keep_rules)
      end
    end
  end
end