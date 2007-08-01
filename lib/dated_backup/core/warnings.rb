
module DatedBackup
  module Warnings
  
  module_function
  def execute_silently(&blk)
    old_warning_level = $VERBOSE
    $VERBOSE = nil
    yield
    $VERBOSE = old_warning_level
  end

  end
end