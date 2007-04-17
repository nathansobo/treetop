require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new successful parse result" do
  setup do
    @syntax_node = mock('syntax node yielded by the parse')
    @result = SuccessfulParseResult.new(@syntax_node)
  end
  
  specify "is a success" do
    @result.should be_a_success
    @result.should_not be_a_failure
  end
  
  specify "propagates the value yielded by the parse" do
    @result.value.should == @syntax_node
  end
end