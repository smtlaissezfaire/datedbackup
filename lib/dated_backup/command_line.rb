class DatedBackup
  module CommandLine
    def execute(cmd)
      puts "* running: #{cmd}"
      puts %x(#{cmd})
    end
  end  
end