require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A terminal syntax node" do
  setup do
    input = "foobar"
    interval = 0...3
    @node = TerminalSyntaxNode.new(input, interval)
  end
  
  specify "has the text value of the input over its interval " do
    @node.text_value.should eql "foo"
  end  
end

context "An empty terminal syntax node" do
  setup do
    input = ""
    interval = 0...0
    @node = TerminalSyntaxNode.new(input, interval)
  end
  
  specify "should be epsilon" do
    @node.should be_epsilon
  end
end