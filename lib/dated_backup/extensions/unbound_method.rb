
# nodoc: Do we need this, or should this be deleted?
class UnboundMethod
  
  def method_name
    match_name :method
  end
  
  def class_name
    match_name :class
  end

  def defined_in
    x = match_name :inheriter
    x.nil? || x.empty? ? class_name : instance_eval(x)
  end
  
  protected
  
  def match_name(type=:method)
    string = self.to_s
    string =~ /\#\<(\w*?)\: (\w*)\(?(\w*?)\)?\#(.*)\>/
    case type
    when :method
      return $4.to_sym
    when :class
      return instance_eval $2
    when :inheriter
      return $3
    end
  end
  
  
end