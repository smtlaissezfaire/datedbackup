require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module DatedBackup
  class Core
    describe TimeSymbol do
      it "should be able to initialize with :year" do
        TimeSymbol.new(:year)
      end
  
      it "should be able to initialize with :month" do
        TimeSymbol.new(:month)
      end
  
      it "should be able to initialize with :day" do
        TimeSymbol.new :day
      end
  
      it "should be able to initialize with :week" do
        TimeSymbol.new :week
      end
  
      it "should raise an error with any other symbol" do
        lambda { TimeSymbol.new :another_sym }.should raise_error(TimeSymbolError, "The symbol given must be a valid TimeSymbol (:year, :month, :week, or :day)")
      end
    end

    describe TimeSymbol, ":year" do
      before :each do
        @ts = TimeSymbol.new :year
      end
  
      it "should have singular as :year" do
        @ts.singular.should == :year
      end
  
      it "should have to_singular which is equivalent to #singular" do
        @ts.to_singular.should == :year
      end
  
      it "should have the plural as :years" do
        @ts.plural.should == :years
      end
  
      it "should have #to_plural which is equivalent to #plural" do
        @ts.to_plural.should == @ts.plural
      end
  
      it "should have the adverb as :yearly" do
        @ts.adverb.should == :yearly
      end
  
      it "should have #to_adverb which is equivalent to #adverb" do
        @ts.to_adverb.should == @ts.adverb
      end
  
      it "should have the plural_adverb as :yearlies" do
        @ts.plural_adverb.should == :yearlies
      end
  
      it "should have #to_plural_adverb, which is equivalent to #plural_adverb" do
        @ts.to_plural_adverb.should == @ts.plural_adverb
      end
    end

    describe TimeSymbol, ":month" do
      before :each do
        @ts = TimeSymbol.new :month
      end
  
      it "should have singular as :month" do
        @ts.singular.should == :month
      end
  
      it "should have to_singular which is equivalent to #singular" do
        @ts.to_singular.should == :month
      end
  
      it "should have the plural as :months" do
        @ts.plural.should == :months
      end
  
      it "should have #to_plural which is equivalent to #plural" do
        @ts.to_plural.should == @ts.plural
      end
  
      it "should have the adverb as :monthly" do
        @ts.adverb.should == :monthly
      end

      it "should have #to_adverb which is equivalent to #adverb" do
        @ts.to_adverb.should == @ts.adverb
      end
  
      it "should have the plural_adverb as :monthlies" do
        @ts.plural_adverb.should == :monthlies
      end
  
      it "should have #to_plural_adverb, which is equivalent to #plural_adverb" do
        @ts.to_plural_adverb.should == @ts.plural_adverb
      end
    end

    describe TimeSymbol, ":week" do
      before :each do
        @ts = TimeSymbol.new :week
      end
  
      it "should have singular as :week" do
        @ts.singular.should == :week
      end
  
      it "should have to_singular which is equivalent to #singular" do
        @ts.to_singular.should == :week
      end
  
      it "should have the plural as :weeks" do
        @ts.plural.should == :weeks
      end
  
      it "should have #to_plural which is equivalent to #plural" do
        @ts.to_plural.should == @ts.plural
      end
  
      it "should have the adverb as :weekly" do
        @ts.adverb.should == :weekly
      end
  
      it "should have #to_adverb which is equivalent to #adverb" do
        @ts.to_adverb.should == @ts.adverb
      end
  
      it "should have the plural_adverb as :weeklies" do
        @ts.plural_adverb.should == :weeklies
      end
  
      it "should have #to_plural_adverb, which is equivalent to #plural_adverb" do
        @ts.to_plural_adverb.should == @ts.plural_adverb
      end
    end

    describe TimeSymbol, ":day" do
      before :each do
        @ts = TimeSymbol.new :day
      end
  
      it "should have singular as :day" do
        @ts.singular.should == :day
      end
  
      it "should have to_singular which is equivalent to #singular" do
        @ts.to_singular.should == :day
      end
  
      it "should have the plural as :days" do
        @ts.plural.should == :days
      end
  
      it "should have #to_plural which is equivalent to #plural" do
        @ts.to_plural.should == @ts.plural
      end
  
      it "should have the adverb as :dayly" do
        @ts.adverb.should == :daily
      end
  
      it "should have #to_adverb which is equivalent to #adverb" do
        @ts.to_adverb.should == @ts.adverb
      end
  
      it "should have the plural_adverb as :dailies" do
        @ts.plural_adverb.should == :dailies
      end
  
      it "should have #to_plural_adverb, which is equivalent to #plural_adverb" do
        @ts.to_plural_adverb.should == @ts.plural_adverb
      end
    end

    describe TimeSymbol, "all class method" do
      it "should return an array of valid symbols" do
        TimeSymbol.all.should == [:year, :month, :week, :day]
      end
  
      it "should have valid_symbols as an alias" do
        TimeSymbol.valid_symbols.should == TimeSymbol.all
      end
    end

    describe TimeSymbol, "conversion methods" do
      it "should return the singular version of the symbol when to_sym is called" do
        TimeSymbol.new(:month).to_sym.should == :month
      end
  
      it "should return the singular version of the symbol as a string when to_s is called" do
        TimeSymbol.new(:month).to_s.should == "month"
      end
  
      it "should call the singular symbol's inspect to inspect" do
        TimeSymbol.new(:month).inspect.should == :month.inspect
      end
    end
  end
end