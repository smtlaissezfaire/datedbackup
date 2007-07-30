
class Array
  def empty_or_nil?
    self.empty? || self.nil? || self == [nil] ? true : false
  end
  
  def car
    first
  end
  
  def cdr
    self.[](1..self.length)
  end
end

# A subclass of Array, but it calls uniq!, sort!, and reverse!
# (in that order) after the instance is created
class ReverseSortedUniqueArray < Array
  
  def initialize *args, &blk
    super *args, &blk
    uniq!
    sort!
    reverse!
  end    
  
end
