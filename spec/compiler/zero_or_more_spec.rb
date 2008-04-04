require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ZeroOrMoreSpec
  class Foo < Treetop::Runtime::SyntaxNode
  end

  describe "zero or more of a terminal symbol followed by a node class declaration and a block" do
    testing_expression '"foo"* <ZeroOrMoreSpec::Foo> { def a_method; end }'
  
    describe "upon successfully parsing epsilon" do
      attr_reader :result
      
      before do
        @result = parse('')
      end
      
      describe "the result" do
        it "is an instance of the declared node class" do
          result.should be_an_instance_of(Foo)
        end
        
        it "responds to the method defined in the inline block" do
          result.should respond_to(:a_method)
        end

        it "has an interval that includes the site of the repetition-terminating failure" do
          result.interval.should == (0..0)
        end

        it "depends on failure of the repeated subexpression" do
          dependencies = result.dependencies
          dependencies.size.should == 1
          dependencies.first.should be_an_instance_of(Runtime::TerminalParseFailure)
          dependencies.first.expected_string.should == 'foo'
        end
      end
      
      it "records a #terminal_failure" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures.first
        failure.index.should == 0
        failure.expected_string.should == 'foo'
      end
    end

    describe "upon parsing two of the repeated subexpression in a row" do
      attr_reader :result
      
      before do
        @result = parse('foofoo')
      end
      
      describe "the result" do
        it "is an instance of the declared node class" do
          result.should be_an_instance_of(Foo)
        end
        
        it "responds to the method defined in the inline block" do
          result.should respond_to(:a_method)
        end

        it "has an interval that includes the site of the repetition-terminating failure" do
          result.interval.should == (0..6)
        end

        it "depends on the failed parsing of the repeated subexpression" do
          dependencies = result.dependencies
          dependencies.size.should == 1
          dependencies.first.should be_an_instance_of(Runtime::TerminalParseFailure)
          dependencies.first.index.should == 6
          dependencies.first.expected_string.should == 'foo'
        end
      end

      it "records the failure of the third parsing attempt in #terminal_failures" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures.first
        failure.index.should == 6
        failure.expected_string.should == 'foo'
      end
    end
  end

  describe "Zero or more of a sequence" do
    testing_expression '("foo" "bar")*'
  
    it "returns a result that whose interval inclusively ends at the site of the repetition-terminating failure" do
      parse('foobarfoo', :consume_all_input => false) do |result|
        result.should_not be_nil
        result.interval.should == (0..6)
      end
    end
  end

  describe "Zero or more of a choice" do
    testing_expression '("a" / "b")*'

    it "successfully parses matching input" do
      parse('abba').should_not be_nil
    end
  end
end
