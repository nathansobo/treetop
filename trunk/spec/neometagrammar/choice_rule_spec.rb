dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the choice rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:choice)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a choice between terminals" do
    @parser.parse("'a' / 'b' / 'c'").should be_success
  end
    
  it "successfully parses a choice between nonterminals" do
    @parser.parse("a / b / c").should be_success
  end
  
  it "successfully parses a choice between sequences of terminals" do
    @parser.parse("'a' 'b' / 'c' 'd' 'e' / 'f' 'g'").should be_success
  end
  
  it "successfully parses a choice between parenthesized ordered choices" do
    @parser.parse("('a' / 'b') / ('c' / 'd' / 'e')").should be_success
  end
end