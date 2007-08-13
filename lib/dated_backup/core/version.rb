module DatedBackup
  module Version
    MAJOR = 0
    MINOR = 2
    TINY = 1
    
    def string
      "#{MAJOR}.#{MINOR}.#{TINY}"
    end
    
    module_function :string
  end
end