require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe TerminalParseFailure do
  before(:each) do
    @index = 5
    @terminal = mock('terminal expression')
    @failure = TerminalParseFailure.new(@index, @terminal)
  end
  
  it "knows the index at which the failure occurred" do
    @failure.index.should == @index
  end
  
  it "retains a reference to the failing terminal expression" do
    @failure.expression.should == @terminal
  end
  
  it "returns itself as its only nested failure" do
    @failure.nested_failures.should == [@failure]
  end
end