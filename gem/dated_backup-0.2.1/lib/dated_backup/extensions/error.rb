
# Base Class Errors
class TimeSymbolError < StandardError; end
class StringToTimeConversionError < StandardError; end

# DatedBackup Errors
class DatedBackupError < StandardError; end
class DirectoryError < DatedBackupError; end
class InvalidDirectoryError < DirectoryError; end
class NoBlockGiven < DatedBackupError; end
class InvalidKeyError < DatedBackupError; end

