dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the trailing_block rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:trailing_block)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "generates Ruby a space followed by a block based on the Ruby generated for the expression preceding the block" do
    result = @parser.parse(" {}")
    result.should be_success
    result.to_ruby('preceding_expression_ruby').should == 'preceding_expression_ruby {}'
  end
  
  it "returns a node that returns the Ruby for the preceding expression unchanged when matching epsilon" do
    result = @parser.parse("")
    result.should be_success
    result.to_ruby('preceding_expression_ruby').should == 'preceding_expression_ruby'
  end
end