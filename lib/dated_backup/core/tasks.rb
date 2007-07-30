
module DatedBackup
  class Core
    module Tasks
      def run_tasks
        create_main_backup_directory                     
        cp_last_backup_to_new_backup unless Dir.glob("#{@backup_root}/*").empty?
        create_backup
      end

      def create_backup 
        sources.each do |source|        
          cmd = "rsync -a --delete #{options} #{source} #{destination}"
          execute cmd, kernel
          puts "\n\n"
        end
      end

      def cp_last_backup_to_new_backup
        last_backup_dir = find_last_backup_filename

        cmd = "cp -al #{last_backup_dir} #{destination}"
        execute cmd, kernel
      end           

      def create_main_backup_directory
        unless File.exists? backup_root
          kernel.puts "* Creating main backup directory #{backup_root}"
          Dir.mkdir backup_root 
        end
      end
    end
  end
end