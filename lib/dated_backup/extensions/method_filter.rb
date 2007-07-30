
module MethodDispatcher
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

      def call_method(sym, obj, *args, &blk)
        method(sym).bind(obj).call *args, &blk
      end
      
      alias :__method :method
      
    protected
    
      def method(sym)
        @methods.each do |unbound_method|
          return unbound_method if unbound_method.method_name == sym
        end
      end
    end
    
  end
  
  def dispatcher
    MethodDispatcher
  end
  

  module MethodFilter
    def add_filters
      s = self

      sclass = class << self; self; end
      sclass.class_eval do

        methods = s.instance_methods - Object.instance_methods
        methods -= ["before_all", "after_all", "dispatcher", "method_missing"]

        methods.each do |method|
          MethodDispatcher.add_method s.instance_method(method.to_sym)
          s.send :undef_method, method
        end    
      end
    end
  end
  
  def respond_to?(sym, private_methods=false)
    MethodDispatcher.has_method?(sym) || super
  end
  
  private
  
  def around_method?(sym)
    sym == :before_all || sym == :after_all ? true : false
  end
  
  def method_missing(sym, *args, &blk)
    @call_stack ||= []
    @method_calls ||= []

    if MethodDispatcher.has_method? sym 
      # This part is buggy and will lead to an infinite recursion
      # if the before_all or after_all methods call an instance method
      # on the current class (assuming the method exists before the point
      # of mixin).  
      #before_all
      #MethodDispatcher.call_method sym, self, *args, &blk
      #after_all
    else
      super
    end
  end
      
end

