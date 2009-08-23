require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module DatedBackup
  
  describe ExecutionContext, ":main" do
    before :each do
      @filename = mock String
      @filename2 = mock String
      ExecutionContext::Main.stub!(:load).and_return nil
    end

    it "should call DatedBackup::DSL::Main.load with the first filename" do
      ExecutionContext::Main.should_receive(:load).with(@filename).and_return nil
      ExecutionContext.new(:main, @filename)
    end

    it "should call DatedBackup::DSL::Main.load with the second filename" do
      ExecutionContext::Main.should_receive(:load).with(@filename2).and_return nil
      ExecutionContext.new(:main, @filename, @filename2)
    end
  end

  describe ExecutionContext, ":before and :after" do    
    before :each do
      @blk = Proc.new {}
      ExecutionContext::Around.stub!(:new).and_return nil
    end

    it "should call Around.new with the block given with :before" do
      ExecutionContext::Around.should_receive(:new).with(&@blk)
      ExecutionContext.new(:before, &@blk)
    end

    it "should call the Around.new with the block given with :after" do
      ExecutionContext::Around.should_receive(:new).with(&@blk)
      ExecutionContext.new(:after, &@blk)
    end
  end
  
  describe ExecutionContext, "turning off warnings" do
    before :each do
      DatedBackup::Warnings.stub!(:execute_silently).and_return nil
    end
    
    it "should turn off the warnings when executing" do
      DatedBackup::Warnings.should_receive(:execute_silently).and_return nil
      DatedBackup::ExecutionContext.new(nil)
    end
  end
  
end

module DatedBackup
  class ExecutionContext

    describe Around do
      before do
        @blk = Proc.new {}
      end
  
      it "should initialize by instance eval'ing the block" do
        @around = mock Around 
        @around.stub!(:instance_eval).and_return nil
    
        @around.should_receive(:instance_eval).with(&@blk)
        Around.new(@around, &@blk)
      end
    end

    describe Around, "__anonymous_time_class" do
      before :each do
        @proc = lambda { }
        @around = Around.new(&@proc)
      end
      
      it "should return a new anonymous class" do
        @around.__anonymous_time_class.kind_of?(Class).should be_true
      end
      
      it "should return a new anonymous class with DSL::TimeExtensions included" do
        @around.__anonymous_time_class.included_modules.include?(DSL::TimeExtensions).should be_true
      end
      
      it "should return a new anonymous class with the class extended by DSL::TimeExtensions::ClassMethods" do
        @klass = @around.__anonymous_time_class
        DSL::TimeExtensions::ClassMethods.instance_methods.each do |method|
          @klass.respond_to?(method).should be_true
        end
      end
      
      it "should return the new anonymous class with the added time methods" do
        methods ||= []
        Core::TimeSymbol.valid_symbols.each do |sym|
          sym = Core::TimeSymbol.new(sym)
          methods += [sym.singular, sym.plural, sym.adverb, sym.plural_adverb]
        end
        
        methods.each do |m|
          @around.__anonymous_time_class.new.respond_to?(m).should be_true
        end
      end
    end
    
    describe Around, "__eval_in_context time" do
      before :each do
        @klass = Class.new
        @instance = @klass.new
        
        @klass.stub!(:new).and_return @instance
        
        @proc = Proc.new { }
        @around = Around.new(&@proc)
        @around.stub!(:__anonymous_time_class).and_return @klass
      end
      
      it "should return a new instance of the anonymous class" do
        @around.__eval_in_context(:time, &@proc).kind_of?(@klass).should be_true
      end
      
      it "should instance_eval the block given" do
        @instance.should_receive(:instance_eval).and_return true
        @around.__eval_in_context(:time, &@proc)
      end
    end
    
    describe Around, "removal of old backups" do
      
      before :each do
        @main_instance = mock(Object)
        @main_instance.stub!(:backup_root).and_return "/foo/bar"
        Main.stub!(:instance).and_return @main_instance
        
        @proc = Proc.new { }
        @around = Around.new(&@proc)
        @instance = mock(Object)
        @instance.stub!(:kept).and_return Hash.new
        @around.stub!(:__eval_in_context).and_return @instance
      end
      
      it "should call the BackupRemover with the Main instance's backup root and the DSL's rules" do
        DatedBackup::Core::BackupRemover.should_receive(:remove!).with(@main_instance.backup_root, @instance.kept)
        @around.remove_old(&@proc)
      end
    end
    
    describe Main, "__anonymous_class" do
      before :each do
      end
      
      it "should return an anonymous class" do
        Main.__anonymous_class.kind_of?(Class).should be_true
      end
      
      it "should return an anonymous class which includes the Main DSL" do
        Main.__anonymous_class.included_modules.include?(::DatedBackup::DSL::Main).should be_true
      end
    end
    
    describe Main, "__new_anonymous_class_instance" do
      before :each do
        @class = Class.new
        Main.stub!(:__anonymous_class).and_return @class
      end
      
      it "should return a new instance of the anonymous class" do
        Main.__new_anonymous_class_instance.kind_of?(@class).should be_true
      end
    end
    
    describe Main, "__instance_eval_file_in_new_anonymous_class" do
      before :each do
        @filename = "foo.config"
        @contents = "foo bar baz"
        File.stub!(:read).and_return @contents
        
        @instance = Object.new
        Main.stub!(:__new_anonymous_class_instance).and_return(@instance)
        @instance.stub!(:instance_eval).and_return true
      end

      it "should read the file contents" do
        File.should_receive(:read).with(@filename).and_return(@contents)
        Main.__instance_eval_file_in_new_anonymous_class(@filename)
      end
      
      it "should instance eval the contents of the file in the context of the new anonymous object" do
        @instance.should_receive(:instance_eval).with(@contents).and_return(@instance)
        Main.__instance_eval_file_in_new_anonymous_class(@filename)
      end
      
      it "should return the new instance of the anonymous class which has been instance evaled" do
        Main.__instance_eval_file_in_new_anonymous_class(@filename).should == @instance
      end
    end
    
    describe Main, "load class method" do
      before :each do
        @filename = "foo"
        @instance = mock(Object)
        @instance.stub!(:procs).and_return({:before => @proc, :after => @proc })
        @instance.stub!(:hash).and_return({:source => ["dir1"], :destination => ["dir2"]}) 
        
        Main.stub!(:__instance_eval_file_in_new_anonymous_class).and_return @instance
        
        @db = mock(DatedBackup::Core)
        @db.stub!(:set_attributes).and_return nil
        @db.stub!(:run).and_return nil
        
        DatedBackup::Core.stub!(:new).and_return @db
      end
      
      it "should accept the filename as it's params" do
        Main.load(@filename)
      end
      
      it "should obtain a new instance of the anonymous class and instance eval the file" do
        Main.should_receive(:__instance_eval_file_in_new_anonymous_class).with(@filename).and_return @instance
        Main.load(@filename)
      end
      
      it "should create the DatedBackup object with the before and after procs" do
        DatedBackup::Core.should_receive(:new).with({:before => @proc, :after => @proc}).and_return @db
        Main.load(@filename)
      end
      
      it "should set the attributes on the DatedBackup instance" do
        @db.should_receive(:set_attributes).with( 
        {
          :source => ['dir1'],
          :destination => ['dir2']
        }).and_return nil
        Main.load(@filename)
      end
      
      it "should call run after the attributes have been set on the dated backup instance" do
        @db.should_receive(:run).with(no_args).and_return nil
        Main.load(@filename)
      end
    end
    
    describe Main, "core/main instance" do
      before :each do
        File.stub!(:read).and_return ""
        @core_mock = mock DatedBackup::Core
        DatedBackup::Core.stub!(:new).and_return(@core_mock)
        @core_mock.stub!(:set_attributes).and_return nil
        @core_mock.stub!(:run)
      end
      
      it "should have class level main instance available" do
        ExecutionContext::Main.load("mock filename")
        ExecutionContext::Main.main_instance.should == @core_mock
      end
      
      it "should have core instance which is a synonym for a the main instance" do
        ExecutionContext::Main.load("mock filename")
        ExecutionContext::Main.core_instance.should == @core_mock
      end
      
      it "should have the instance, which is a synonymn for the main the instance" do
        ExecutionContext::Main.load("mock filename")
        ExecutionContext::Main.instance.should == @core_mock
      end
    end
    
  end
end
