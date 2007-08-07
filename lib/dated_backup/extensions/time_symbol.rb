
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
  
  alias :to_singular :singular
  
  def plural
    "#{@sym}s".to_sym
  end
  
  alias :to_plural :plural
  
  def adverb
    if @sym == :day
      :daily
    else
      "#{@sym}ly".to_sym
    end
  end
  
  alias :to_adverb :adverb
  
  # should refactor the rest of the methods like this one,..!!!
  #
  #
  def plural_adverb
    @sym == :day ? :dailies : "#{@sym}lies".to_sym
  end
  
  alias :to_plural_adverb :plural_adverb
  
  def to_sym
    @sym.to_sym
  end
  
  def to_s
    @sym.to_s
  end
  
  def inspect
    @sym.inspect
  end
end

TimeSymbols = TimeSymbol.all