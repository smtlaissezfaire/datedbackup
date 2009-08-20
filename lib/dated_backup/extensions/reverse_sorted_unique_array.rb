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
