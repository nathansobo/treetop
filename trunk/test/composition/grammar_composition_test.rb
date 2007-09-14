dir = File.dirname(__FILE__)
require File.join(dir, '..', 'test_helper')

class GrammarCompositionTest < Screw::Unit::TestCase
  def setup
    dir = File.dirname(__FILE__)
    load_grammar File.join(dir, 'a')
    load_grammar File.join(dir, 'b')
    load_grammar File.join(dir, 'c')
    load_grammar File.join(dir, 'd')
    
    @c = ::Test::CParser.new
    @d = ::Test::DParser.new
  end
  
  test "rules in C have access to rules defined in A and B" do
    @c.parse('abc').should be_success
  end
  
  test "rules in C can override rules in A and B with super semantics" do
    @d.parse('superkeywordworks').should be_success
  end
end