require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A choice between terminal symbols" do
  testing_expression '"foo" / "bar" / "baz"'

  it "successfully parses input matching any of the alternatives" do
    parse('foo').should be_success
    parse('bar').should be_success
    parse('baz').should be_success
  end
  
  it "attaches the nested failure of the first terminal to a successful parsing of input matching the second" do
    result = parse('bar')
    result.nested_failures.size.should == 1
    nested_failure = result.nested_failures[0]
    nested_failure.expected_string.should == 'foo'
    nested_failure.index.should == 0
  end
  
  it "attaches the nested failure of the first and second terminal to a successful parsing of input matching the third" do
    result = parse('baz')
    result.nested_failures.size.should == 2

    first_nested_failure = result.nested_failures[0]
    first_nested_failure.expected_string == 'foo'
    first_nested_failure.index.should == 0
    
    first_nested_failure = result.nested_failures[1]
    first_nested_failure.expected_string == 'bar'
    first_nested_failure.index.should == 0
  end
end

describe "A choice between sequences" do
  testing_expression "'foo' 'bar' 'baz'\n/\n'bing' 'bang' 'boom'"

  it "successfully parses input matching any of the alternatives" do
    parse('foobarbaz').should be_success
    parse('bingbangboom').should be_success
  end
end