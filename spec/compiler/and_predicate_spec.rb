require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module AndPredicateSpec
  include Runtime

  describe "An &-predicated terminal symbol" do
    testing_expression '&"foo"'

    it "successfully parses input matching the terminal symbol, returning an epsilon syntax node that depends on the result of the subexpression" do
      parse('foo', :consume_all_input => false) do |result|
        result.should_not be_nil
        result.interval.should == (0...0)
        dependencies = result.dependencies
        dependencies.size.should == 1
        dependencies.first.text_value.should == 'foo'
      end
    end

    it "stores the successful result of the predicated expression in the node cache with itself as a dependent expression" do
      result = parse('foo', :consume_all_input => false)
      node_cache = parser.send(:expirable_node_cache)
      node = node_cache.get(:__anonymous__, 0)
      node.text_value.should == 'foo'
      node.dependent_results.should == [result]
    end

    it "stores the failure of the predicated expression in the node cache with itself as a dependent expression" do
      result = parse('bar', :consume_all_input => false, :return_parse_failure => true)
      node_cache = parser.send(:expirable_node_cache)
      node = node_cache.get(:__anonymous__, 0)
      node.should be_an_instance_of(TerminalParseFailure)
      node.interval.should == (0...3)
      node.dependent_results.should == [result]
    end
  end

  describe "A sequence of a terminal and an and another &-predicated terminal" do
    testing_expression '"foo" &"bar"'

    it "matches input matching both terminals, but only consumes the first" do
      parse('foobar', :consume_all_input => false) do |result|
        result.should_not be_nil
        result.text_value.should == 'foo'
      end
    end
  
    it "fails to parse input matching only the first terminal, with a terminal failure recorded at index 3" do
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