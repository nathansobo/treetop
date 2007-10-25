require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "A choice between terminal symbols", :extend => CompilerTestCase do
  testing_expression '"foo" { def foo_method; end } / "bar" { def bar_method; end } / "baz" { def baz_method; end }'

  it "successfully parses input matching any of the alternatives, returning a node that responds to methods defined in its respective inline module" do
    result = parse('foo')
    result.should be_success
    result.should respond_to(:foo_method)
    
    result = parse('bar')
    result.should be_success
    result.should respond_to(:bar_method)
    
    result = parse('baz')
    result.should be_success
    result.should respond_to(:baz_method)
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

describe "A choice between sequences", :extend => CompilerTestCase do
  testing_expression "'foo' 'bar' 'baz'\n/\n'bing' 'bang' 'boom'"

  it "successfully parses input matching any of the alternatives" do
    parse('foobarbaz').should be_success
    parse('bingbangboom').should be_success
  end
end

describe "A choice between terminals followed by a block", :extend => CompilerTestCase do  
  testing_expression "('a'/ 'b' / 'c') { def a_method; end }"

  it "extends a match of any of its subexpressions with a module created from the block" do
    ['a', 'b', 'c'].each do |letter|
      parse(letter).should respond_to(:a_method)
    end
  end
end
