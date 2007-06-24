dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the primary rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:primary)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses a terminal followed by a block" do
    @parser.parse("'foo' { def a_method; end }").should be_success
  end
  
  it "successfully parses one or more of a nonterminal followed by a block" do
    @parser.parse("foo+ { def a_method; end }").should be_success    
  end
  
  it "successfully parses a parenthesized sequence of terminals followed by a block" do
    @parser.parse("('a' 'b' 'c') { def a_method; end }")
  end
  
end