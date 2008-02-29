require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module AndPredicateSpec
  include Runtime

  describe "An &-predicated terminal symbol" do
    attr_reader :result
    
    testing_expression '&"foo"'

    describe "the result of parsing input matching the predicated subexpression" do
      before do
        @result = parse('foo', :consume_all_input => false)
      end

      it "is an epsilon node" do
        result.should be_epsilon
        result.interval.should == (0...0)
      end
      
      it "depends on the result of the predicated subexpression" do
        dependencies = result.dependencies
        dependencies.size.should == 1
        dependencies.first.text_value.should == 'foo'
      end
    end
    
    describe "the result of parsing input that does not match the predicated subexpression" do
      before do
        @result = parse('bar', :consume_all_input => false, :return_parse_failure => true)
      end

      it "is not successful" do
        result.should be_an_instance_of(Runtime::ParseFailure)
      end
      
      it "depends on the failure of the subexpression" do
        dependencies = result.dependencies
        dependencies.size.should == 1
        dependencies.first.expected_string.should == 'foo'
      end
    end
  end

  describe "A sequence of a terminal and an and another &-predicated terminal" do
    testing_expression '"foo" &"bar"'
    
    describe "the result of parsing input that matches both terminals" do
      attr_reader :result
      
      before do
        @result = parse('foobar', :consume_all_input => false)
      end
      
      it "is successful" do
        result.should_not be_nil
      end
      
      it "has the result of the first terminal and an epsilon node as its elements" do
        result.elements[0].text_value.should == 'foo'
        result.elements[1].should be_epsilon
      end
      
      it "depends on its elements" do
        result.dependencies.should == result.elements
      end
    end
    
    it "fails to parse input matching only the first terminal, recording a terminal failure at index 3" do
      parse('foo') do |result|
        result.should be_nil
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures[0]
        failure.index.should == 3
        failure.expected_string.should == 'bar'
      end
    end
  end
end