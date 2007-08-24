require File.join(File.dirname(__FILE__), '..', 'test_helper')
 
class SequenceTest < CompilerTestCase

  class Foo < Treetop2::Parser::SyntaxNode
  end

  testing_expression '"foo" "bar" "baz" <Foo> { def a_method; end }'
  
  it "parses matching input successfully, returning an instance of the declared node class that responds to a method defined in the inline block" do
    parse('foobarbaz') do |result|
      result.should be_success
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
      (result.elements.map {|elt| elt.text_value}).should == ['foo', 'bar', 'baz']
    end
  end
  
  it "parses matching input at a non-zero index successfully" do
    parse('---foobarbaz', :at_index => 3) do |result|
      result.should be_success
      result.should be_nonterminal
      (result.elements.map {|elt| elt.text_value}).join.should == 'foobarbaz'
    end
  end
  
  it "fails to parse non-matching input with a nested failure at the first terminal that did not match" do
    parse('---foobazbaz', :at_index => 3) do |result|
      result.should be_failure
      result.index.should == 3
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'bar'
    end
  end
end
