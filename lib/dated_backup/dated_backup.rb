require File.dirname(__FILE__) + "/command_line"

class DatedBackup    
  
  include DatedBackup::CommandLine
  
  attr_accessor :source, :destination, :opts, :backup_root, :user_domain
  
  def initialize(h={})
    @backup_root = h[:destination]
    @opts = h[:options] || ""
    @user_domain = h[:user_domain]
    @destination = generate_backup_filename
    
    @sources = h[:sources] || [h[:source]]
    
    if @user_domain
      @sources.map! { |src| "#{@user_domain}:#{src}" }
    end
    
  end
  
  # create the first backup, if non-existent  
  # otherwise cp -al (or # replace cp -al a b with cd a && find . -print | cpio -dpl ../b )
  # and then create the backup of the dirs using rsync -a --delete
  # the files, in the end, should be read only and undeletable
  def run                               
    create_main_backup_directory                     
    cp_last_backup_to_new_backup unless Dir.glob("#{@backup_root}/*").empty?
    create_backup
    #set_permissions(dest)
  end
  
  def create_backup 
    @sources.each do |source|        
      cmd = "rsync -a --delete #{opts} #{source} #{@destination}"
      execute(cmd)
      puts "\n\n"
    end
  end

  def cp_last_backup_to_new_backup
    last_backup_dir = find_last_backup_filename
    
    cmd = "cp -al #{last_backup_dir} #{@destination}"
    execute(cmd)
  end           
  
  def create_main_backup_directory
    begin
      unless File.exists? backup_root
        puts "* Creating main backup directory #{backup_root}"
        Dir.mkdir backup_root 
      end
    rescue Errno::EACCES => e
      puts "-- Exiting script because main directory could not be created. \n   Error Message: #{e}"
      exit
    end
  end
  
  #def set_permissions(file, permission="400", user="root", group="root")
  #  cmd = "chmod -R #{permission} #{file}"
  #  execute(cmd)
  #  cmd = "chown -R #{user}:#{group} #{file}"
  #  execute(cmd)
  #end

private

  def generate_backup_filename
    timestamp = Time.now.strftime "%Y-%m-%d-%Hh-%Mm-%Ss"
    "#{@backup_root}/#{timestamp}"
  end                         

  def find_last_backup_filename
    Dir.glob("#{@backup_root}/*").sort.last
  end
end


