dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the block rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:block)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses and generates Ruby for an empty block" do
    result = @parser.parse('{}')
    result.should be_success
    result.to_ruby.should == '{}'
  end
  
  it "successfully parses an empty block with space between the braces" do
    result = @parser.parse('{  }')
    result.should be_success
    result.to_ruby.should == '{  }'
  end
  
  it "successfully parses a block containing another Ruby block and represents it as itself" do
    block = "{[1, 2, 3].map {|x| x + 1}}"
    result = @parser.parse(block)
    result.should be_success
    result.to_ruby.should == block
  end
end
