dir = File.dirname(__FILE__)
require File.join(dir, '..', 'spec_helper')

module GrammarCompositionSpec
  describe "several composed grammars" do
    before do
      dir = File.dirname(__FILE__)
      load_grammar File.join(dir, 'a')
      load_grammar File.join(dir, 'b')
      load_grammar File.join(dir, 'c')
      load_grammar File.join(dir, 'd')
  
      @c = ::Test::CParser.new
      @d = ::Test::DParser.new
    end

    specify "rules in C have access to rules defined in A and B" do
      @c.parse('abc').should_not be_nil
    end

    specify "rules in C can override rules in A and B with super semantics" do
      @d.parse('superkeywordworks').should_not be_nil
    end
  end
end
