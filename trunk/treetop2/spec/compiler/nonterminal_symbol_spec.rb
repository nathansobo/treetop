require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A nonterminal symbol" do
  testing_expression 'foo'
  
  before do
    parser_class_under_test.class_eval do
      def _nt_foo
        '_nt_foo called'
      end
    end
  end
  
  it "compiles to a message send" do
    parse('').should == '_nt_foo called'
  end
end