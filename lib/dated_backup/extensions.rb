require "using"

module DatedBackup
  module Extensions
    extend Using
    
    using :Time
    using :Error
    using :TimeSymbol
    using :TimeString
  end
end