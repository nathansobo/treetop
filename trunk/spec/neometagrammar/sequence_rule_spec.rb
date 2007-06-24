dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the sequence rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:sequence)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a sequence of terminals" do
    @parser.parse("'a' 'b' 'c'")
  end
  
  it "successfully parses a sequence of nonterminals" do
    @parser.parse("a b c")
  end
  
  it "successfully parses a sequence of terminals, each followed by blocks" do
    @parser.parse("'a' { def a_method; end } 'b' { def b_method; end } 'c' { def c_method; end }")
  end
  
  it "successfully parses a sequence of parenthesized choices" do
    @parser.parse("(a / b) (c / d) (e / f)")
  end
  
  it "successfully parses a sequence repeated nonterminals, each followed by blocks" do
    @parser.parse("a+ { def a_method; end } b* { def b_method; end } c+ { def c_method; end }")
  end
  
  it "successfully parses a sequence of nonterminals followed by a block" do
    @parser.parse("a b c { def a_method; end }")
  end
end