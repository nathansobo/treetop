dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the anything_symbol rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:anything_symbol)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "parses and generates Ruby for a . character" do
    node = @parser.parse('.')
    node.should be_success
    value = eval(node.to_ruby)
    value.should be_an_instance_of(AnythingSymbol)
  end
end