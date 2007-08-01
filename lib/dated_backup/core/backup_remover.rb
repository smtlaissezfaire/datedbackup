

module DatedBackup
  class Core
    class BackupRemover
      class << self
        
        include DatedBackup::Core::CommandLine
        
        def remove!(dir, rules=[])
          complete_set = BackupSet.find_files_in_directory dir
          
          execute("rm -rf #{set_to_remove(complete_set, rules).map{ |element| "#{element} " }.to_s.strip}")
        end
        
        private
        
        def set_to_remove(set, rules)
          if rules.empty?
            return []
          else
            to_remove = set - set.filter_by_rule(rules.car)
            return(to_remove - set_to_remove(to_remove, rules.cdr))
          end
        end
      end

    end
  end
end