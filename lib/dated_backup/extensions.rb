require "using"

module DatedBackup
  module Extensions
    extend Using
    
    using :Array
    using :Time
    using :Error
    using :TimeSymbol
    using :String
    using :ReverseSortedUniqueArray
  end
end