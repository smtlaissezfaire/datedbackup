require File.dirname(__FILE__) + "/../../spec_helper"

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
  
end



module DatedBackup
  class ExecutionContext
    
    
    module CommonMock
      def common_mock
        @klass = mock Class
        @klass.stub!(:send).and_return @klass
        @klass.stub!(:include).and_return true
        Class.stub!(:new).and_return @klass
        @instance = mock @klass
        @klass.stub!(:new).and_return @instance      
      end
    end

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

    describe Around, "remove_old" do
      include CommonMock
      
      before do
        @blk = Proc.new {}
        common_mock
        
        @instance.stub!(:instance_eval).and_return nil
        @around = Around.new(@instance, &@blk)
      end
      
      
      it "should create a new anonymous class" do
        Class.should_receive(:new).and_return @klass
        @around.remove_old
      end

      it "should include the TimeExtension module" do
        @klass.should_receive(:send).with(:include, ::DatedBackup::DSL::TimeExtensions).and_return true
        @around.remove_old
      end

      it "should create a new instance of the anonymous class" do
        @klass.should_receive(:new).and_return @instance
        @around.remove_old
      end

      it "should instance eval the block inside the instance of the anonymous class" do
        @instance.should_receive(:instance_eval).with(&@blk)
        @around.remove_old
      end
    end 
    
    describe Main, "load class method" do
      include CommonMock
      
      before :each do
        @db = mock DatedBackup::Core
        @db.stub!(:set_attributes).and_return nil
        @db.stub!(:run).and_return nil
        DatedBackup::Core.stub!(:new).and_return @db

        @filename = mock String
        @contents = mock String
        @file = mock 'File'
        File.stub!(:open).and_yield @file
        @file.stub!(:read).and_return @contents
        
        @proc = Proc.new {}
        common_mock
        
        @instance.stub!(:instance_eval).and_return @instance
        @instance.stub!(:procs).and_return({:before => @proc, :after => @proc })
        @instance.stub!(:hash).and_return({:source => ["dir1"], :destination => ["dir2"]}) 
      end
      
      it "should accept the filename as it's params" do
        Main.load(@filename)
      end
      
      it "should create a new anonymous class" do
        Class.should_receive(:new).and_return @klass
        Main.load(@filename)
      end
      
      it "should create a new instance of the anonymous class" do
        @klass.should_receive(:new).and_return @instance
        Main.load @filename
      end
      
      it "should include the Main module" do
        @klass.should_receive(:send).with(:include, ::DatedBackup::DSL::Main).and_return true
        Main.load @filename
      end
      
      it "should open the file given with filename" do
        File.should_receive(:open).with(@filename, "r").and_yield @file
        Main.load @filename
      end
      
      it "should read the file contents" do
        @file.should_receive(:read).and_return @contents
        Main.load @filename
      end
      
      it "should instance eval the contents of the file in the context of the new anonymous object" do
        @instance.should_receive(:instance_eval).with(@contents).and_return @instance
        Main.load @filename
      end

      it "should create a new DatedBackup object" do
        DatedBackup::Core.should_receive(:new).and_return @db
        Main.load @filename
      end

      it "should create the DatedBackup object with the before and after procs" do
        DatedBackup::Core.should_receive(:new).with({:before => @proc, :after => @proc}).and_return @db
        Main.load @filename
      end
      
      it "should set the attributes on the DatedBackup instance" do
        @db.should_receive(:set_attributes).with( 
        {
          :source => ['dir1'],
          :destination => ['dir2']
        }).and_return nil
        Main.load @filename
      end
      
      it "should call run after the attributes have been set on the dated backup instance" do
        @db.should_receive(:run).with(no_args).and_return nil
        Main.load @filename
      end
    end
    
    describe Main, "core/main instance" do
      before :each do
        File.stub!(:open).and_return nil
        @core_mock = mock DatedBackup::Core
        DatedBackup::Core.stub!(:new).and_return @core_mock
        @core_mock.stub!(:set_attributes).and_return nil
        @core_mock.stub!(:run).and_return nil
      end
      
      it "should have class level main instance available" do
        ExecutionContext::Main.load "mock filename"
        ExecutionContext::Main.main_instance.should == @core_mock
      end
      
      it "should have core instance which is a synonym for a the main instance" do
        ExecutionContext::Main.load "mock filename"
        ExecutionContext::Main.core_instance.should == @core_mock
      end
      
      it "should have the instance, which is a synonymn for the main the instance" do
        ExecutionContext::Main.load "mock filename"
        ExecutionContext::Main.instance.should == @core_mock
      end
    end
    
  end
end
