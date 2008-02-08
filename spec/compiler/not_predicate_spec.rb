require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NotPredicateSpec
  include Runtime

  describe "A !-predicated terminal symbol" do
    testing_expression '!"foo"'

    it "fails to parse input matching the terminal symbol" do
      parse('foo').should be_nil
    end

    it "stores the successful result of the predicated expression in the node cache with itself as a dependent expression" do
      result = parse('foo', :consume_all_input => false, :return_parse_failure => true)
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
      node.interval.should == (0..3)
      node.dependent_results.should == [result]
    end
  end

  describe "A sequence of a terminal and an and another !-predicated terminal" do
    testing_expression '"foo" !"bar"'

    it "fails to match input matching both terminals" do
      parse('foobar').should be_nil
    end
  
    it "successfully parses input matching the first terminal and not the second, reporting the parse failure of the second terminal" do
      parse('foo') do |result|
        result.should_not be_nil
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures.first
        failure.index.should == 3
        failure.expected_string.should == 'bar'
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