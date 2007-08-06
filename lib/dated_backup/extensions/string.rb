
class StringToTimeConversionError < RuntimeError
  
end

class String
  # This must take a time in a format similar to the
  # format generated the Time.to_string.  The format should be like this:
  # .+2007-07-01-00m-00h-00s.+
  # Any number of charachters can come before or after the time format
  # string.  A TimeException will be raised if the string does not 
  # conform to the time format.
  def to_time
    if self =~ /(\d{4}\-\d{2}-\d{2}-\d{2}h\-\d{2}m-\d{2}s)/  
      begin
        time_array = $1.gsub(/h|m|s/, '').split '-'
        Time.gm(*time_array)
      rescue 
        raise StringToTimeConversionError, "The string cannot be a converted to a valid time (it is out of range)"
      end
    else
      raise StringToTimeConversionError, "The string cannot be converted to a time object"
    end
  end
end