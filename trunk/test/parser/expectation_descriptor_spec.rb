require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of ExpectationDescriptor" do
  setup do
    @expression = mock('parsing expression')
    @descriptor = ExpectationDescriptor.new(@expression)
  end
  
  specify "retains a reference to an expression that did not match, causing a parse failure" do
    @descriptor.expression.should == @expression
  end
end