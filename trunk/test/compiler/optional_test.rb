require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "An optional terminal symbol", :extend => CompilerTestCase do
  testing_expression_2 '"foo"?'
  
  it "parses input matching the terminal" do
    parse('foo').should be_success
  end
  
  it "parses epsilon, with a nested failure" do
    parse('') do |result|
      result.should be_success
      result.interval.should == (0...0)
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 0
      nested_failure.expected_string.should == 'foo'
    end
  end
  
  it "parses input not matching the terminal, returning an epsilon result with a nested failure" do
    parse('bar') do |result|
      result.should be_success
      result.interval.should == (0...0)
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 0
      nested_failure.expected_string.should == 'foo'
    end
  end
end

