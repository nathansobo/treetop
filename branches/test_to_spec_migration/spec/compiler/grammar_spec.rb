require File.join(File.dirname(__FILE__), '..', 'spec_helper')

#FIXME: Move this back into grammarspec
module GrammarSpecBar
end

module GrammarSpec
  describe "a grammar" do
    testing_grammar %{
      grammar Foo
        include GrammarSpecBar
    
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
  
    it "fails if it does not parse all input" do
      parse('barbarbazbaz').should be_failure
    end
  
    it "mixes in included modules" do
      self.class.const_get(:Foo).ancestors.should include(GrammarSpecBar)
    end
  end
end