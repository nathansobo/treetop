dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the atomic rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:atomic)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a nonterminal" do
    @parser.parse('foo').should be_success
  end
  
  it "successfully parses a terminal" do
    @parser.parse("'foo'").should be_success
  end
  
  it "successfully parses a parenthesized repeated expression" do
    @parser.parse("(foo+)").should be_success
  end
  
  it "successfully parses a parenthesized optional expression" do
    @parser.parse("(foo?)").should be_success
  end
end