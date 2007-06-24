dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the instantiator_primary rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:instantiator_primary)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
      
  it "successfully parses zero or more of a nonterminal" do
    @parser.parse('foo*').should be_success
  end
  
  it "successfully parses one or more of a nonterminal" do
    @parser.parse('foo+').should be_success
  end

  it "successfully parses zero or more of a terminal" do
    @parser.parse('"foo"*').should be_success
  end
    
  it "successfully parses one or more of a terminal" do
    @parser.parse('"foo"+').should be_success
  end
  
  it "successfully parses zero or more of a sequence"
  
  it "successfully parses one or more of a choice"
end