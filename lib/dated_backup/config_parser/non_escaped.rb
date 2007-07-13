
class Object
  def metaclass
    class << self; self; end
  end
end

class DatedBackup
  class DSL
      
    module UtilityFunctions
      # split by escaped data and non-escaped data
      # and for each non-escaped_data, yield that data
      # finally, rebuild the entire string, with the rules from
      # the escaped and non-escaped data in their original order
      def non_escaped_data(data)
        filter(data, /(.*?)(\'.*?\')/) do |non_escaped|
          yield non_escaped
        end
      end      
      
      def filter(data, pattern)
        scanned_data = data.scan(pattern) 
        scanned_data = [[data]] if scanned_data.nil? || scanned_data.empty?

        scanned_data.each do |array|
          original = array.first
          modified = original.dup
          
          #modify_with_side_effects :complete_data => data, 
          #                         :original_data => original,
          #                         :modified_data => modified, 
          #                         :methods => [:gsub!, :strip!]
          
          
            # TODO: CLEAN THIS UP & ABSTRACT IT

            # would have used def for the methods, 
            # and class << modified;....; end, but needed
            # a closure to get to scanned, original, and data variables
            modified.metaclass.class_eval do
              alias_method :old_gsub!, :gsub!
              alias_method :old_strip!, :strip!

              instance_eval do
                
                define_method :strip! do 
                  modified.old_strip!
                  data.gsub! original, modified
                end
                
                define_method :gsub! do |search, replace|
                  modified.old_gsub! search, replace
                  data.gsub! original, modified
                end
              end
            end          
          
          
          
          
          yield modified
        end        
      end
      
      def filter_keys(data)
        filter(data, /^(.*?)=/) do |key|
          yield key
        end
      end
      
      def filter_values(data)
        filter(data, /^.*?=(.*)/) do |value|
          yield value
        end
      end
      
      
      def modify_with_side_effects(h)

      end
      
    end
      
  end
end