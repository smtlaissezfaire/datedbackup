
class AnonymousClass
  
  def initialize(&blk)
    @klass = Class.new
    @klass.instance_eval(&blk) if block_given?
  end
  
  def include(*mods)
    mods.each do |mod|
      @klass.send(:include, mod)
    end
  end
  
  def new
    @klass.new
  end
  
  def evaluate(&blk)
    @klass.instance_eval(&blk)
  end
  
  def send(sym, *args, &blk)
    @klass.send(sym, *args, &blk)
  end
  
  attr_reader :klass
  alias_method :class, :klass
end
