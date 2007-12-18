dir = File.dirname(__FILE__)
require File.join(dir, '..', 'spec_helper')

module GrammarCompositionSpec
  describe "several composed grammars" do
    before do
      dir = File.dirname(__FILE__)
      Treetop.load File.join(dir, 'a')
      Treetop.load File.join(dir, 'b')
      Treetop.load File.join(dir, 'c')
      # Check that polyglot finds d.treetop and loads it:
      $: << dir
      require 'd'
  
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
