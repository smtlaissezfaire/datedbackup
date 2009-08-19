require "using"

module DatedBackup
  class Dsl
    extend Using
    
    using :ExecutionContext
    using :Main
    using :TimeExtensions
  end
end
