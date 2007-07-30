

class UnboundMethod
  def method_name
    match_name :method
  end
  
  def class_name
    match_name :class
  end
  
  # will be nil if the method is defined
  # in the class, given by class_name
  def inheriter
    match_name :inheriter
  end
  
  protected
  
  def match_name(type=:method)
    string = self.to_s
    string =~ /\#\<(.*)\: (.*?)\(?.*?\)?\#(.*)\>/
    case type
    when :method
      return $4
    when :class
      return $2
    when :inheriter
      return $3
    end
  end
end

module MethodFilter

end


class UniqueArray < Array
  
require 'rubygems'; require 'ruby-debug'; debugger;

  include MethodFilter
  

  class MethodDispatcher

    @methods = []
    
    class << self
      
      def add_methods(*methods)
        methods.each do |m|
          @methods << m
        end
      end
      
      def add_method(method)
        add_methods method
      end
    
      def has_method?(sym)
        @methods.each do |method|
          return true if method.method_name == sym
        end
        false
      end
      
      def method(sym)
        @methods.each do |method|
          return method if method == sym
        end
      end
    
      def call_method(obj, sym, *args, &blk)
        method(sym).bind(obj).call *args, &blk
      end

    end
    
  end
  
  
  methods = instance_methods - Object.instance_methods - ["before", "after"]
  
  methods.each do |method|
    MethodDispatcher.add_method instance_method(method.to_sym)
    undef_method method
  end
  
  def before
    puts "hi"
  end
  
  def after
    
  end
  
  def method_missing(sym, *args, &blk)
    require 'rubygems'; require 'ruby-debug'; debugger;
    if MethodDispatcher.has_method? sym
      before
      MethodDispatcher.call sym, *args, &blk
      after
    else
      super
    end
  end
  
  #def respond_to?(sym, inc_private = false)
  #  if inc_private == false
  #    super || MethodDispatcher.has_method?(sym)
  #  else
  #    super
  #  end
  #end

  
  
end

require 'rubygems'; require 'ruby-debug'; debugger;
ua = UniqueArray.new [2, 3, 1]

puts ua.sort!
