
module DatedBackup
  class Core
    module Tasks
      
      def run_tasks
        create_main_backup_directory                     
        #cp_last_backup_to_new_backup unless Dir.glob("#{@backup_root}/*").empty?
        create_backup
      end

      def create_backup
        additional_options = has_backup? ? "--link-dest #{latest_backup} " : ""
        
        sources.each do |source|        
          cmd = "rsync -a --delete #{additional_options}#{options} #{source} #{destination}"
          execute cmd, kernel
          kernel.puts "\n\n"
        end
      end

      def cp_last_backup_to_new_backup
        last_backup_dir = find_latest_backup

        cmd = "cp -al #{last_backup_dir} #{destination}"
        execute cmd, kernel
      end           

      def create_main_backup_directory
        unless File.exists? backup_root
          kernel.puts "* Creating main backup directory #{backup_root}"
          Dir.mkdir backup_root 
        end
      end

      def find_latest_backup
        backup_directories.sort.reverse.first
      end
      
      alias :latest_backup :find_latest_backup
      
      def backup_directories
        Dir.glob("#{backup_root}/*").grep(BACKUP_REGEXP)
      end
      
      def has_backup?
        backup_directories.empty? ? false : true
      end
      
    end
  end
end