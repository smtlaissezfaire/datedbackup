
class String
  def to_time
    string = self.dup
    string.sub!(/^(.*?)([\d\-\h\m\s]+)(.*?)$/) { $2 }
    Time.gm(*(string.split('-').map { |element| element.sub /h|m|s/, ''}))
  end
end

module DatedBackup
  class Core
    class BackupRemover
      

    end
  end
end