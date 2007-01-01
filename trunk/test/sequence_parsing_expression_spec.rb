require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A sequence parsing expression" do
  setup do
    @sequence = SequenceParsingExpression.new
  end

  specify "is a kind of CompositeParsingExpression" do
    @sequence.should_be_a_kind_of SequenceParsingExpression
  end
  
end