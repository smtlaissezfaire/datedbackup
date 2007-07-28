
class Array
  def empty_or_nil?
    self.empty? || self.nil? || self == [nil] ? true : false
  end
end

class ReverseSortedUniqueArray < Array
  
  def initialize *args, &blk
    super *args, &blk
    uniq!
    sort!
    reverse!
  end    
  
end
