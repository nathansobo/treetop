require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A !-predicated terminal symbol" do
  testing_expression '!"foo"'
  
  it "fails to parse input matching the terminal symbol" do
    parse('foo').should be_failure
  end
end

describe "A sequence of a terminal and an and another !-predicated terminal" do
  testing_expression '"foo" !"bar"'

  it "fails to match input matching both terminals" do
    parse('foobar').should be_failure
  end
  
  it "successfully parses input matching the first terminal and not the second, with the failure of the second as a nested failure" do
    parse('foo') do |result|
      result.should be_success
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures[0]
      nested_failure.index.should == 3
      nested_failure.expected_string.should == 'bar'
    end
  end
end