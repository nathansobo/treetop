require File.join(File.dirname(__FILE__), '..', 'test_helper')

class OneOrMoreOfTerminalTest < CompilerTestCase
  testing_expression '"foo"+ <Foo> { def a_method; end }'

  class Foo < Treetop2::Parser::SyntaxNode
  end

  it "fails to parse epsilon with a nested failure" do
    parse('') do |result|
      result.should be_failure
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 0
      nested_failure.expected_string.should == 'foo'
    end
  end
  
  it "successfully parses two of that terminal in a row, returning an instance of the declared node class with a nested failure representing the third attempt" do
    parse("foofoo") do |result|
      result.should be_success
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'foo'
    end
  end
end