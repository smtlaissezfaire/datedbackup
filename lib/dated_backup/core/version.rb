module DatedBackup
  module Version
    
    MAJOR = 0 unless const_defined?("MAJOR")
    MINOR = 2 unless const_defined?("MINOR")
    TINY  = 1 unless const_defined?("TINY")

    def string
      "#{MAJOR}.#{MINOR}.#{TINY}"
    end

    module_function :string

  end
end