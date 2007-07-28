
class String
  def to_time
    string = self.dup
    string.sub!(/^(.*?)([\d\-\h\m\s]+)(.*?)$/) { $2 }
    Time.gm(*(string.split('-').map { |element| element.sub /h|m|s/, ''}))
  end
end

class Array
  def to_time_array
    TimeArray.new(self)
  end
end


require 'set'

class Set
  
  def reject(&blk)
    copy = self.dup
    copy.reject! &blk
    copy
  end
end

class Array
  def to_set
    Set.new(self)
  end
end

module DatedBackup
  class Core
    class BackupRemover
      
      attr_reader :to_remove, :to_keep
      
      def initialize(directory)
        @directory = directory
        @to_remove = Set.new
        @to_keep = Set.new
      end
      
      def build_directories(rules=[])
        @all_directories = Set.new Dir.glob("#{@directory}/*")
        
        rules.each do |rule|
          if time_range = rule[:constraint]
            remove_constraints(rule, time_range)
          end
            
        end
        
        @to_remove = @all_directories - @to_keep
        
        #if rule[:constraint]
        #  tmp = @all_directories.dup
        #  remove_constraints!(tmp, rule[:constraint])
        #end
      end
      

      #def remove!(keep_rules=[])
      #  
      #  
      #  keep_rules.each do |rule|
      #    build_directories_to_keep(rule)
      #  end
      #
      #  @to_remove = @all_directories - @to_keep
      #end
      
      
    private
    
      def remove_constraints(rule, time_range)
        
      end

      #
      #def remove_constraints!(set, time_range)
      #  set.reject do |element|
      #    timestamp = element.to_time
      #    time_range.include? timestamp
      #  end
      #end
    
    end

  end
end