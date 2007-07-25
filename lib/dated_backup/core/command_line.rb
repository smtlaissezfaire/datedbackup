module DatedBackup
  module CommandLine
    def execute(cmd, kernel_class=Kernel)
      kernel_class.puts "* running: #{cmd}"
      output = kernel_class.send :`, cmd
      kernel_class.puts output
    end
  end  
end