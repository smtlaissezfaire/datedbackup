
require File.dirname(__FILE__) + "/../spec_helper"

dsl = DatedBackup::DSL::Main

describe dsl, "file handling" do
  before :each do
    @file_path = mock String
    @file_contents = mock String
    
    @file_class = mock 'File:Class'
    @file = mock File
    @file_class.stub!(:open).and_return @file
    @file.stub!(:read).and_return @file_contents
    
    @dsl_instance = mock dsl
    @dsl_instance.stub!(:parse!).and_return @dsl_instance
    @dsl_instance.stub!(:data_hash).and_return Hash.new
    dsl.stub!(:new).and_return @dsl_instance
  end
  
  it "should be able to open a file" do
    @file_class.should_receive(:open).with(@file_path, "r").and_return @file
    dsl.parse(@file_path, @file_class)
  end
  
  it "should be able to read the file" do
    @file.should_receive(:read).with no_args
    dsl.parse(@file_path, @file_class)
  end
  
  it "should parse the data with a new instance" do
    dsl.should_receive(:new).and_return @dsl_instance
    @dsl_instance.should_receive(:parse!).with(@file_contents).and_return @dsl_instance
    
    dsl.parse(@file_path, @file_class)
  end
  
  it "should return the data hash" do
    @dsl_instance.should_receive(:data_hash).with no_args
    dsl.parse(@file_path, @file_class)
  end
  
  it "should raise an error if open fails" 
  it "should raise an error if read fails" 
end

describe dsl, "parsing" do
  before :each do
    @dsl = dsl.new
    @dsl.keys = ["key1"]
  end
  
  it "should have user definable keys" do
    @dsl.keys = ["key1", "key2"]
    @dsl.keys.should == ["key1", "key2"]
  end
  
  it "should parse a key with one element" do
    @dsl.parse! "key1=val1"
    #@dsl.parsed_data.should == "assign_key(:key1, \"val1\")"
    @dsl.data_hash.should == {:key1 => ["val1"]}
  end
  
  it "should parse a key with one element and with any arbitrary whitespace between the key and it's value" do
    @dsl.parse! "key1=\t\t \rval1"
    #@dsl.parsed_data.should == "assign_key(:key1, \"val1\")"
    @dsl.data_hash.should == {:key1 => ["val1"]}
  end
  
  it "should parse a key with one element and many values" do
    @dsl.parse! "key1=val1,val2"
    @dsl.data_hash.should == {:key1 => ["val1", "val2"]}
  end
  
  it "should parse a key with one element and many values, with whitespace between the values" do
    @dsl.parse! "key1=val1,\t\t\tval2"
    @dsl.data_hash.should == {:key1 => ["val1", "val2"]}
  end
  
  it "should parse a key with one element and many values, even with newlines between the values" do
    @dsl.parse! "key1 = val1,\n\t\tval2"
    @dsl.data_hash.should == {:key1 => ["val1", "val2"]}
  end
  
  it "should remove any whitespace (such as tabs, newlines, etc.) except for the space in a value" do
    @dsl.parse! "key1 = val1,\n\t\tva l2"
    @dsl.data_hash.should == {:key1 => ["val1", "va l2"]}
  end
  
  it "should parse a key even if there is whitespace between the key and its' value separator (the equal sign)" do
    @dsl.parse! "key1 \t\t\t    = val1"
    @dsl.data_hash.should == {:key1 => ["val1"]}
  end
  
  it "should not parse a comment line (which begins with a #)" do
    @dsl.parse! "# here is a comment\nkey1=val1"
    @dsl.data_hash.should == {:key1 => ["val1"]}
  end
  
  it "should not parse the rest of the line after a comment symbol is given" do
    @dsl.parse! "key1=val1 # here is a comment on this key"
    @dsl.data_hash.should == {:key1 => ["val1"]}
  end
  
  it "should parse each line for comments" do
    @dsl.parse! "key1=val1 # the first comment\n# a comment on a new line\n\n\nkey2=val2 # a third comment"
    @dsl.data_hash.should == {:key1 => ["val1"], :key2 => ["val2"]}
  end
  
  it "should parse multi key value pairs" do
    @dsl.parse! "key1 = val1, val2\nkey2 = val1,val2,\n\t\tval3"
    @dsl.data_hash.should == {
      :key1 => ["val1", "val2"],
      :key2 => ["val1", "val2", "val3"]
    }
  end
  
  it "should handle abnormal characters like -- as values" do
    @dsl.parse! "key1 = --value"
    @dsl.data_hash.should == {:key1 => ["--value"]}
  end
end

describe dsl, "escaping" do
  
  before :each do
    @dsl = dsl.new
  end
  
  it "should be able to escape any string given" do
    @dsl.parse! "key1 = \"sudo rsync\""
    @dsl.data_hash.should == {:key1 => ["\"sudo rsync\""]}
  end
  
  it "should be able to accept a value with spaces" do
    @dsl.parse! "key1 = a value with spaces"
    @dsl.data_hash.should == {:key1 => ["a value with spaces"]}
  end
  
  it "should be able to escape an equal sign with the escape char" do
    @dsl.parse! "key1 = %q(some key with an \= sign)\nsome_other_key=val2"
    @dsl.data_hash.should == {
      :key1 => ["some key with an = sign"],
      :some_other_key => ["val2"]
    }
  end
  
  it "should be able to escape a comma, if given the escape signal" do
    @dsl.parse! "key1 = here is a value with a comma %q(\,)"
    @dsl.data_hash.should == {:key1 => ["here is a value with a comma ,"]}
  end
  
  it "should be able to escape an equal sign, if given the escape signal" do
    @dsl.parse! "key1 = here is an equal sign: %q(\=)\nkey2 = val2"
    @dsl.data_hash.should == {
      :key1 => ["here is an equal sign: ="],
      :key2 => ["val2"]
    }
  end
end

describe dsl, "integration testing with examples" do
  before :each do
    @file_path = File.dirname(__FILE__) + "/../../example_scripts"
  end
  
  it "should parse the local_etc_backup script correctly" do
    dsl.parse(@file_path + "/local_etc_backup").should == {
      :source => ["/etc"],
      :destination => ["/root/etc_backup"] 
    }    
  end
  
  it "should parse the samba_shares script correctly" 
  
  it "should parse the example.com script correctly" #do
  #  dsl.parse(@file_path + "/example.com").should == {
  #    :sources => ["/etc", "/home"],
  #    :destination => ["/var/backups/network/backups/example.com"],
  #    :rsync_options => ["--verbose", "-e \"ssh -i /root/.ssh/rsync-key\"", "'--rsync-path = \"sudo rsync\"'"],
  #    :user_domain => ["nbackup@example.com"]
  #  }
  #end
end


