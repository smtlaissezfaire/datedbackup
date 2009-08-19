require "using"

module DatedBackup
  class Core
    extend Using
    
    using :Warnings
    using :BackupSet
    using :Tasks
    using :CommandLine
    using :BackupRemover
    using :DatedBackup
    using :Version
  end
end