
class TimeSymbolError < RuntimeError; end

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
  
  def to_s
    @sym.to_s
  end
  
  alias :inspect :to_s
end

TimeSymbols = TimeSymbol.all