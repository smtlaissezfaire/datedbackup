
class Array
  def empty_or_nil?
    self.empty? || self.nil? || self == [nil] ? true : false
  end
end