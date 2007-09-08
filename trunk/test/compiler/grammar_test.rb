require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GrammarTest < CompilerTestCase
  module Bar
  end

  testing_grammar_2 %{
    grammar Foo
      include Bar
    
      rule foo
        bar / baz
      end
      
      rule bar
        'bar' 'bar'
      end
      
      rule baz
        'baz' 'baz'
      end
    end
  }
  
  it "parses matching input" do
    parse('barbar').should be_success
    parse('bazbaz').should be_success
  end
  
  it "mixes in included modules" do
    Foo.ancestors.should include(Bar)
  end
end