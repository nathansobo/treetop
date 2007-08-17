require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "A grammar with three rules", :extend => CompilerTestCase do
  testing_grammar %{grammar Foo
      rule foo
        bar / baz
      end
      
      rule bar
        'bar' 'bar'
      end
      
      rule baz
        'baz' 'baz'
      end
    end}
  
  it "parses matching input" do
    parse('barbar').should be_success
    parse('bazbaz').should be_success
  end
end