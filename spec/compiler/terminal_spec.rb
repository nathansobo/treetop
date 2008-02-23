require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TerminalSymbolSpec
  include Runtime

  class Foo < SyntaxNode
  end

  describe "a terminal symbol followed by a node class declaration and a block" do
    testing_expression "'foo' <TerminalSymbolSpec::Foo> { def a_method; end }"

    it "correctly parses matching input prefixes at various indices, returning an instance of the declared class that can respond to methods defined in the inline module" do
      parse "foo", :index => 0 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (0...3)
        result.text_value.should == 'foo'
      end

      parse "xfoo", :index => 1 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (1...4)
        result.text_value.should == 'foo'
      end
    
      parse "---foo", :index => 3 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (3...6)
        result.text_value.should == 'foo'
      end
    end

    it "fails to parse nonmatching input at the index even if a match occurs later" do
      parse(" foo", :index =>  0).should be_nil
    end

    it "fails to parse when starting at the end of the buffer, producing a failure whose interval includes its endpoint" do
      failure = parse("bla", :index => 3, :return_parse_failure => true)
      failure.should be_an_instance_of(TerminalParseFailure)
      failure.interval.should == (3..3)
    end

    it "fails to parse if the match runs off the end of the buffer, producing a failure whose interval includes its endpoint" do
      failure = parse("fo", :return_parse_failure => true)
      failure.should be_an_instance_of(TerminalParseFailure)
      failure.interval.should == (0..2)
    end

    it "upon a parse failure, sets the #max_terminal_failure_first_index and #max_terminal_failure_last_index of the parser" do
      parse("xxx").should be_nil
      parser.max_terminal_failure_first_index.should == 0
      parser.max_terminal_failure_last_index.should == 3
    end

    it "upon a parse failure, returns a TerminalParseFailure node with an interval spanning from the index of the failure to the end of the expected string" do
      failure = parse("xxx", :return_parse_failure => true)
      failure.should be_an_instance_of(TerminalParseFailure)
      failure.interval.should == (0...3)
    end
  end
end
