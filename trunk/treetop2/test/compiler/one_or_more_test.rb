require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "One or more of a terminal symbol with a node class declaration", :extend => CompilerTestCase do
  testing_expression '"foo"+ <Foo>'

  class Foo < Treetop2::Parser::SequenceSyntaxNode
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
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'foo'
    end
  end
end