module DatedBackup
  module Version
    
    MAJOR = 0 unless const_defined?("MAJOR")
    MINOR = 2 unless const_defined?("MINOR")
    TINY  = 1 unless const_defined?("TINY")

  module_function

    def to_s
      "#{MAJOR}.#{MINOR}.#{TINY}"
    end

  end
end