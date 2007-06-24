dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the atomic_propagator rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:atomic_propagator)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a nonterminal symbol" do
    @parser.parse('foo').should be_success
  end
  
  it "successfully parses a parenthesized choice"
  
  it "fails to parse a parenthesized terminal"
end