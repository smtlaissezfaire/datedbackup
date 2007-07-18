require File.dirname(__FILE__) + "/command_line"

class Array
  def empty_or_nil?
    self.empty? || self.nil? || self == [nil] ? true : false
  end
end

class DirectoryError < RuntimeError;  end

class DatedBackup    
  
  include DatedBackup::CommandLine
  
  attr_accessor :sources, :destination, :options, :backup_root, :user_domain
  attr_reader :pre_run_commands, :kernel
  
  def initialize(h={}, kernel=Kernel)
    @kernel = kernel
    parse_command_options(h)
    @destination = generate_backup_filename    
    if @user_domain
      @sources.map! { |src| "#{@user_domain}:#{src}" }
    end    
  end
  
  
  def check_for_directory_errors
    if sources.empty_or_nil?
      raise DirectoryError, "No source directory given"
    elsif backup_root.nil? || backup_root.empty?
      raise DirectoryError, "No destination directory given"
    end
  end
  
  
  # create the first backup, if non-existent  
  # otherwise cp -al (or # replace cp -al a b with cd a && find . -print | cpio -dpl ../b )
  # and then create the backup of the dirs using rsync -a --delete
  # the files, in the end, should be read only and undeletable
  def run
    begin
      check_for_directory_errors
      run_tasks
    rescue
      raise DirectoryError, "-- Exiting script because main directory could not be created. \n"      
    end            
  end
  
  def run_tasks
    create_main_backup_directory                     
    cp_last_backup_to_new_backup unless Dir.glob("#{@backup_root}/*").empty?
    create_backup
  end
  
  def create_backup 
    @sources.each do |source|        
      cmd = "rsync -a --delete #{options} #{source} #{@destination}"
      execute cmd, kernel
      puts "\n\n"
    end
  end

  def cp_last_backup_to_new_backup
    last_backup_dir = find_last_backup_filename
    
    cmd = "cp -al #{last_backup_dir} #{@destination}"
    execute cmd, kernel
  end           
  
  def create_main_backup_directory
    unless File.exists? backup_root
      puts "* Creating main backup directory #{backup_root}"
      Dir.mkdir backup_root 
    end
  end
  
private

  def generate_backup_filename
    timestamp = Time.now.strftime "%Y-%m-%d-%Hh-%Mm-%Ss"
    "#{@backup_root}/#{timestamp}"
  end                         

  def find_last_backup_filename
    Dir.glob("#{@backup_root}/*").sort.last
  end
  
protected

  def parse_command_options(h={})
    @pre_run_commands = h["pre_run_commands"]
    @pre_run_commands = h["pre_run_command"].to_a if h["pre_run_command"]
    
    @backup_root = h["destination"]
    @options = h["options"] || ""
    @user_domain = h["user_domain"]    
    
    @sources = h["sources"] || [h["source"]]
  end
  
  
end


