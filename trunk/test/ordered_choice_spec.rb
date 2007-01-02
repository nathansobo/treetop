require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "An ordered choice parsing expression with three alternatives" do
  setup do
    @alts = ["foo", "bar", "baz"]
    @choice = OrderedChoice.new(@alts.collect { |alt| TerminalSymbol.new(alt) })
  end
  
  specify "returns the results of the first alternative if it succeeds" do
    @choice.parse_at(@alts[0], 0, mock("Parser")).text_value.should_eql @alts[0]
  end

  specify "returns the results of the second alternative if it succeeds" do
    @choice.parse_at(@alts[1], 0, mock("Parser")).text_value.should_eql @alts[1]
  end
  
  specify "returns the results of the third alternative if it succeeds" do
    @choice.parse_at(@alts[2], 0, mock("Parser")).text_value.should_eql @alts[2]
  end
  
  specify "returns a ParseFailure if no alternative succeeds" do
    nonmatching_input = "bonk"
    @choice.parse_at(nonmatching_input, 0, mock("Parser")).should_be_an_instance_of ParseFailure
  end
end