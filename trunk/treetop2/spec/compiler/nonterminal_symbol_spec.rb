require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A nonterminal symbol" do
  testing_expression 'foo'
  
  before do
    CompilerBehaviour::Test::TestParser.class_eval do
      def _nt_foo
        '_nt_foo called'
      end
    end
  end
  
  after do
    CompilerBehaviour::Test::TestParser.class_eval { remove_method :_nt_foo }
  end
  
  it "compiles to a message send" do
    parse('').should == '_nt_foo called'
  end
end