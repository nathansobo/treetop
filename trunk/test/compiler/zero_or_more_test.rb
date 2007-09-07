require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ZeroOrMoreOfATerminalWithNodeClassDeclarationTest < CompilerTestCase
  
  class Foo < Treetop::Parser::SyntaxNode
  end

  testing_expression_2 '"foo"* <Foo> { def a_method; end }'
  
  it "successfully parses epsilon, returning an instance declared node class with a nested failure" do
    parse('') do |result|
      result.should be_success
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 0
      nested_failure.expected_string.should == 'foo'
    end
  end
  
  it "successfully parses two of that terminal in a row, returning an instance of the declared node class with a nested failure representing the third attempt " do
    parse("foofoo") do |result|
      result.should be_success
      result.should be_an_instance_of(Foo)
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'foo'
    end
  end
end

describe "Zero or more of a sequence", :extend => CompilerTestCase do
  testing_expression_2 '("foo" "bar")*'
  
  it "resets the index appropriately following partially matcing input" do
    parse('foobarfoo') do |result|
      result.should be_success
      result.interval.should == (0...6)
    end
  end
end

describe "Zero or more of a choice", :extend => CompilerTestCase do
  testing_expression_2 '("a" / "b")*'

  it "successfully parses matching input" do
    parse('abba').should be_success
  end
end