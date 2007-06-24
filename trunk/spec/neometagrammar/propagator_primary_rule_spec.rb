dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the propagator_primary rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:propagator_primary)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses & preceding a terminal" do
    @parser.parse('&"foo"')
  end
  
  it "successfully parses ! preceding a nonterminal" do
    @parser.parse('!foo')
  end
  
  it "successsfully parses & preceding one or more of a nonterminal, which is wasteful but valid" do
    @parser.parse('&foo+')
  end
  
  it "successsfully parses ! preceding zero or more of a parenthesized choice" do
    @parser.parse('!(a / b / c)')
  end
  
  it "successsfully parses an optional nonterminal" do
    @parser.parse('a?')
  end
  
  it "successsfully parses an optional terminal" do
    @parser.parse('"a"?')
  end
    
  it "fails to parse ! or & preceding an optional terminal or nonterminal, because predicating over an optional expression is nonsensical" do
    @parser.parse('!foo?').should be_failure
    @parser.parse('&foo?').should be_failure
    @parser.parse('!"foo"?').should be_failure
    @parser.parse('&"foo"?').should be_failure
  end
end