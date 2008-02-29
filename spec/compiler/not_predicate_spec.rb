require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NotPredicateSpec
  include Runtime

  describe "A !-predicated terminal" do
    testing_expression '!"foo"'

    it "fails to parse input matching the terminal symbol" do
      parse('foo').should be_nil
    end
  end

  describe "A sequence of a terminal and an and another !-predicated terminal" do
    testing_expression '"foo" !"bar"'

    it "fails to match input matching both terminals" do
      parse('foobar').should be_nil
    end
    
    describe "upon parsing input matching the first terminal and not the second" do
      attr_reader :result
      before do
        @result = parse('foo')
      end
      
      describe "the result" do
        it "is successful" do
          result.should_not be_nil
        end
        
        it "has its elements as dependencies" do
          result.dependencies.should == result.elements
        end
        
        it "has the result of the first terminal as its first element" do
          subresult = result.elements[0]
          subresult.should be_terminal
          subresult.text_value.should == 'foo'
        end
        
        it "has the epsilon result of the predicated terminal as its second element, which depends on the failure of the predicated subexpression" do
          subresult = result.elements[1]
          subresult.should be_epsilon
          dependencies = subresult.dependencies
          dependencies.size.should == 1
          dependencies.first.should be_an_instance_of(TerminalParseFailure)
          dependencies.first.index.should == 3
        end
      end
      
      it "stores the parse failure of the predicated terminal in the #terminal_failures array" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        terminal_failures.first.index.should == 3
        terminal_failures.first.expected_string.should == 'bar'
      end
    end
  end

  describe "A !-predicated sequence" do
    testing_expression '!("a" "b" "c")'

    it "fails to parse matching input" do
      parse('abc').should be_nil
    end
  end
end