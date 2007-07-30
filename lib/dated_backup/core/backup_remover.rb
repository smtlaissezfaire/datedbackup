
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
      class << self
        def remove!(dir, rules={})
          complete_set = BackupSet.find_files_in_directory dir
          set_to_remove = remove_successively(complete_set, rules)
          
          Kernel.send :`, "rm -rf #{set_to_remove.map{ |element| "#{element} " }.to_s}"
        end
        
        private
        
        def remove_successively(set, rules)
          if rules.empty?
            return set
          else
            to_remove = set - set.filter_by_rule(rules.car)
            to_remove - remove_successively(to_remove, rules.cdr)
          end
        end
      end

    end
  end
end