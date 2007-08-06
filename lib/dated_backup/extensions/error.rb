
class TimeSymbolError < RuntimeError; end
class StringToTimeConversionError < RuntimeError; end


class DatedBackupError < RuntimeError; end

class DirectoryError < DatedBackupError; end
class InvalidDirectoryError < DirectoryError; end
class NoBlockGiven < DatedBackupError; end
class InvalidKeyError < DatedBackupError; end

