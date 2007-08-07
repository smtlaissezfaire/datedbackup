
class Array
  def car
    first
  end
  
  def cdr
    self.[](1..self.length)
  end
  
  def to_backup_set
    DatedBackup::Core::BackupSet.new(self)
  end
end
