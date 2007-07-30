
# Used to change the the TimeSymbols (:year, :month, :day, and :week) into the
# various natural language forms (the symbols singular, plural, and adverb).  
# Initialize with the singular symbol name, or call TimeSymbol.valid_symbols
# to give an array of valid symbols.
class TimeSymbol
  VALID_TIME_COMPONENTS = [:year, :month, :week, :day]
  
  class << self
    def all
      VALID_TIME_COMPONENTS.dup
    end
    
    alias :valid_symbols :all
  end
  
  def initialize(sym)
    if VALID_TIME_COMPONENTS.include? sym
      @sym = sym
    else
      raise TimeSymbolError, "The symbol given must be a valid TimeSymbol (:year, :month, :week, or :day)"
    end
  end
  
  def singular
    @sym
  end
  
  def plural
    "#{@sym}s".to_sym
  end
  
  def adverb
    if @sym == :day
      :daily
    else
      "#{@sym}ly".to_sym
    end
  end
  
  def to_sym
    @sym.to_sym
  end
  
  def to_s
    @sym.to_s
  end
  
  alias :inspect :to_sym
end

TimeSymbols = TimeSymbol.all