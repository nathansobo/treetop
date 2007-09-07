require File.join(File.dirname(__FILE__), '..', 'test_helper')
 
class SequenceOfTerminalsTest < CompilerTestCase

  class Foo < Treetop2::Parser::SyntaxNode
  end

  testing_expression_2 'foo:"foo" bar:"bar" baz:"baz" <Foo> { def a_method; end }'
  
  test "successful result is an instance of the declared node class with element accessor methods and the method from the inline module" do
    parse('foobarbaz') do |result|
      result.should be_success
      result.should be_an_instance_of(Foo)      
      result.should respond_to(:a_method)
      result.foo.text_value.should == 'foo'
      result.bar.text_value.should == 'bar'
      result.baz.text_value.should == 'baz'
    end
  end
    
  test "matching at a non-zero index" do
    parse('---foobarbaz', :at_index => 3) do |result|
      result.should be_success
      result.should be_nonterminal
      (result.elements.map {|elt| elt.text_value}).join.should == 'foobarbaz'
    end
  end
  
  test "non-matching input fails with a nested failure at the first terminal that did not match" do
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

class SequenceOfNonterminalsTest < CompilerTestCase

  testing_grammar_2 %{
    grammar TestGrammar
      rule sequence
        foo bar baz
      end
      
      rule foo 'foo' end
      rule bar 'bar' end
      rule baz 'baz' end
    end
  }
  
  test "accessors for nonterminals are automatically defined" do
    parse('foobarbaz') do |result|
      result.foo.text_value.should == 'foo'
      result.bar.text_value.should == 'bar'
      result.baz.text_value.should == 'baz'
    end
  end
end
