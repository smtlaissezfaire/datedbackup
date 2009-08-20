module DatedBackup
  module Warnings
    def execute_silently(&blk)
      old_warning_level = $VERBOSE
      $VERBOSE = nil
      yield
      $VERBOSE = old_warning_level
    end
    
    module_function :execute_silently
  end
end