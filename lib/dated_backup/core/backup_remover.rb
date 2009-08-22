module DatedBackup
  class Core
    class BackupRemover
      class << self
        include DatedBackup::Core::CommandLine
        
        def remove!(dir, keep_rules=[])
          find_removable_sets(dir, keep_rules)
          
          unless no_sets_to_remove?
            execute("rm -rf #{to_remove.map{ |element| "#{element} " }.to_s.strip}")
          end
        end
        
      private

        def find_removable_sets(dir, rules)
          complete_set = BackupSet.find_files_in_directory dir
          @to_remove = set_to_remove(complete_set, rules)
        end
        
        attr_reader :to_remove
        
        def no_sets_to_remove?
          to_remove.empty?
        end
        
        def set_to_remove(set, keep_rules)
          if keep_rules.empty?
            set
          else
            to_remove = set - set.filter_by_rule(keep_rules.first)
            return set_to_remove(to_remove, keep_rules.rest)
          end
        end
      end
    end
  end
end