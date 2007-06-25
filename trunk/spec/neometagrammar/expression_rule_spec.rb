dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the expression rule" do
  include MetagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:expression)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a choice between terminals" do
    @parser.parse("'a' / 'b' / 'c'").should be_success
  end
  
  it "successfully parses a sequence of terminals" do
    @parser.parse("'a' 'b' 'c'").should be_success
  end
  
  it "successfully parses a repeated nonterminal" do
    @parser.parse("a+").should be_success
  end
end