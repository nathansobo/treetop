dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the node_class_expression rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:node_class_expression)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_global_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a space followed by a <RubyConstant>" do
    result = @parser.parse(" <Foo>")
    result.should be_success
    result.to_ruby.should == ", Foo"
  end
  
  it "successfully parses and generates Ruby for epsilon" do
    result = @parser.parse("")
    result.should be_success
    result.to_ruby.should == ""    
  end
end