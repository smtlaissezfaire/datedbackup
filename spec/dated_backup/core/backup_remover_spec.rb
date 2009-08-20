require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module DatedBackup
  class Core
    
    module BackupRemoverHelper
      def include_helpers
        BackupSet.stub!(:find_files_in_directory).and_return @complete_set
        BackupRemover.stub!(:execute).and_return nil
      end
    end
    
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
        @backup_set.stub!(:empty?).and_return false
        
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
    
    describe BackupRemover, "removing directories (regression tests)" do
      include BackupRemoverHelper
      
      before :each do
        @complete_set = BackupSet.new [
          "/root/etc_backup/2007-08-01-16h-36m-47s", 
          "/root/etc_backup/2007-08-01-16h-28m-59s", 
          "/root/etc_backup/2007-07-31-07h-16m-15s",
          "/root/etc_backup/2007-07-20-16h-27m-03s", ]
        @backup_root = "/root/etc_backup"
        @keep_rules = [{
          :scope => :monthly, 
          :constraint => Time.gm('1969', '12', '31', '19')...Time.gm('2007', '08', '01', '16', '37', '10')
        }]

        include_helpers
      end
      
      it "should remove the directories" do
        Core::BackupRemover.should_receive(:execute).with("rm -rf /root/etc_backup/2007-08-01-16h-28m-59s /root/etc_backup/2007-07-20-16h-27m-03s")
        Core::BackupRemover.remove!(@backup_root, @keep_rules)
      end
      
      
      it "should not issue the rm command if no directories are found" do
        BackupSet.stub!(:find_files_in_directory).and_return BackupSet.new([])
        
        BackupRemover.should_not_receive(:execute)
        BackupRemover.remove!(@backup_root, @keep_rules)
      end
      
      it "should not issue the rm command if no directories match the filter rules" do
        BackupRemover.should_not_receive(:execute)
        BackupRemover.remove!(@backup_root, [{:constraint => Time.gm(1970)...Time.gm(2019)}])
      end
    end
    
    describe BackupRemover, "removing directories with multiple filter rules (regression test)" do
      include BackupRemoverHelper
      
      before :each do
        @complete_set = BackupSet.new [
          "/root/etc_backup/2007-08-01-16h-36m-47s", 
          "/root/etc_backup/2007-08-01-16h-28m-59s", 
          "/root/etc_backup/2007-07-31-07h-16m-15s",
          "/root/etc_backup/2007-07-20-16h-27m-03s"
        ]
        @backup_root = "/root/etc_backup"
        @keep_rules = [
          # keep backups from this day
          {
            :constraint => Time.gm('2007', '08', '01')...Time.gm('2007', '08', '01', '23', '59', '59')
          },          
          # keep monthly backups
          {
            :scope => :monthly, 
            :constraint=>Time.gm('2007', '01', '01')...Time.gm('2007', '08', '01', '16', '37', '10')
          }
        ]
        
        include_helpers
      end
      
      it "should issue the rm command only on the one directory which does not match the filter rule" do
        BackupRemover.should_receive(:execute).with("rm -rf /root/etc_backup/2007-07-20-16h-27m-03s").and_return nil
        BackupRemover.remove!(@backup_root, @keep_rules)
      end
    end
  
  
    describe BackupRemover, "regression test for multiple filter rules w/ deletion for samba shares script" do
      include BackupRemoverHelper
      
      before :each do
        Time.stub!(:now).and_return Time.gm('2007', 'Aug', '06', '06', '33', '46')
      
        @complete_set = BackupSet.new [
          "/var/backups/network/backups/shares/2007-08-06-01h-41m-47s", 
          "/var/backups/network/backups/shares/2007-08-03-01h-05m-15s"
        ]
        @backup_root = "/var/backups/network/backups/shares"
        @keep_rules = [
          {:constraint => Time.gm('2007', 'Aug', '06')...Time.gm('2007', 'Aug', '06')}, 
          {:constraint => Time.gm('2007', 'Jul', '30')...Time.gm('2007', 'Aug', '05')}, 
          {:scope => :weekly , :constraint => Time.gm('2007', 'Aug', '01')...Time.gm('2007', 'Aug', '06', '06', '33', '46')}, 
          {:scope => :weekly , :constraint => Time.gm('2007', 'Jul', '01')...Time.gm('2007', 'Jul', '31', '23', '59', '59')}, 
          {:scope => :monthly, :constraint => Time.gm('1969', 'Dec', '31')...Time.gm('2007', 'Aug', '06', '06', '33', '46')}
        ]
        
        include_helpers
      end
      
      it "should delete none of the files" do
        BackupRemover.should_not_receive(:execute)
        BackupRemover.remove!(@backup_root, @keep_rules)
      end
    end
  
  end
end