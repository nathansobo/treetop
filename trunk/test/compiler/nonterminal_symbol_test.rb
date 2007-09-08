require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "A nonterminal symbol", :extend => CompilerTestCase do
  testing_expression 'foo'
  
  parser_class_under_test.class_eval do
    def _nt_foo
      '_nt_foo called'
    end
  end
  
  it "compiles to a message send" do
    parse('').should == '_nt_foo called'
  end
end