require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "An optional terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @optional = Optional.new(@terminal)
  end
  
  specify "returns an empty terminal node on parsing epsilon" do
    epsilon = ""
    result = @optional.parse_at(epsilon, 0, mock("Parser"))
    result.should_be_an_instance_of TerminalSyntaxNode
    result.should_be_epsilon
  end
  
  specify "returns a terminal node matching the terminal symbol on parsing matching input" do
    result = @optional.parse_at(@terminal.prefix, 0, mock("Parser"))
    result.should_be_an_instance_of TerminalSyntaxNode
    result.text_value.should_eql @terminal.prefix
  end
end