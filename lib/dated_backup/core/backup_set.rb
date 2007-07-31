
module DatedBackup
  class Core
    
    class BackupSet < ReverseSortedUniqueArray

      class << self    
        # Given the base of the backup directories as a string, this method should find all of the Backup Directories,
        # and return these Directories as a BackupSet
        def find_files_in_directory(dir)
          raise InvalidDirectoryError, "A valid directory must be given." unless File.directory?(dir)
          new(Dir.glob "#{dir}/*")
        end
        
        # Creates the boolean include_*? methods (include_month?, include_year? and so on).
        # See the notes on the create_per_time_methods, and TimeSymbol.valid_symbols
        def create_include_time_boolean_methods(*methods)
          methods.each do |method|
            define_method "include_#{method}?" do |time_value|
              truth_value = false
              self.each_as_time do |t|
                truth_value = true if t.send(method) == time_value
              end
              truth_value
            end
          end
        end    

        # Creates the one_per_* (one_per_month, one_per_year, one_per_week, and one_per_day)
        # methods.  Each of those methods will call the appropriate include_* methods,
        # which is also dynamically defined
        def create_one_per_time_methods(*methods)
          methods.each do |method|
            define_method "one_per_#{method}" do 
              set = BackupSet.new
              reject_with_string_and_timestamp do |string, timestamp|
                set.push string unless set.send("include_#{method}?", timestamp.send("#{method}"))
              end
              set
            end      
          end
        end

        # Creates the many similar time methods:
        #
        # * include_year?
        # * include_month?
        # * include_day?
        # * include_week
        #
        # * one_per_year
        # * one_per_month
        # * one_per_day
        # * one_per_week
        #
        def create_dynamic_time_methods(time_array=[])
          create_include_time_boolean_methods *time_array
          create_one_per_time_methods *time_array
        end    
      end

      create_dynamic_time_methods TimeSymbol.valid_symbols

      def filter_by_rule(rule)
        obj = self.dup
        obj = obj.filter_by_range(rule[:constraint]) if rule[:constraint]
        obj = obj.filter_by_scope(rule[:scope]) if rule[:scope]
        return obj
      end

      def filter_by_scope(scope)
        case scope
        when :yearly
          one_per_year
        when :monthly
          one_per_month
        when :weekly
          one_per_week
        when :daily
          one_per_day
        end    
      end

      def filter_by_range(time_range)
        reject_with_timestamp do |timestamp| 
          !(time_range.include? timestamp)
        end
      end

      def reject_with_timestamp &blk
        reject do |element|
          yield element.to_time
        end
      end

      def reject_with_string_and_timestamp &blk
        reject do |element|
          yield element, element.to_time
        end
      end

      def each_as_time &blk
        self.each do |obj|
          yield obj.to_time
        end
      end
      
      define_method "-" do |obj|
        (self.to_a - obj.to_a).to_backup_set
      end
      
      #alias_method :__array_subtraction, '-'
      #
      ## This needed to be added because subtracting of 
      ## two backup sets results in an Array, not a new instance of BackupSet
      #define_method '-' do |obj|
      #  require 'rubygems'; require 'ruby-debug'; debugger;
      #  self.to_a - 
      #end
     

    end
        
  end
end

