
class TimeSymbolError < RuntimeError;       end

class DatedBackupError < RuntimeError;      end
class DirectoryError < DatedBackupError;    end
class NoBlockGiven < DatedBackupError;      end
class InvalidKeyError < DatedBackupError;   end

