require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A terminal syntax node" do
  before do
    input = "foobar"
    interval = 0...3
    @node = TerminalSyntaxNode.new(input, interval)
  end
  
  it "has the text value of the input over its interval " do
    @node.text_value.should == "foo"
  end  
end

describe "An empty terminal syntax node" do
  before do
    input = ""
    interval = 0...0
    @node = TerminalSyntaxNode.new(input, interval)
  end
  
  it "should be epsilon" do
    @node.should be_epsilon
  end
end