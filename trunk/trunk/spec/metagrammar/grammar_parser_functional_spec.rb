require 'rubygems'
require 'spec/runner'


dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
=begin
context "An arithmetic grammar defined via the parsing of arithmetic.treetop" do
  setup do
    Arithmetic = parse_grammar("#{dir}/arithmetic")
  end
  
  specify "is an instance of Grammar" do
    Arithmetic.should_be_an_instance_of Grammar
  end
end

context "A parser for an arithmetic grammar defined via a file" do
  setup do
    Arithmetic = parse_grammar("#{dir}/arithmetic")
    parser = Arithmetic.new_parser
  end
  
  specify "returns a result has the correct value for a digit" do
    parser.parse("5").value.should_equal 5
  end
  
  specify "succeeds for a multi-digit decimal" do
    parser.parse("5346").value.should_equal 5346
  end
    
  specify "succeeds for a parenthesized decimal" do
    parser.parse("(53)").value.should_equal 53
  end
  
  specify "succeeds for a multiplication" do
    parser.parse("45*4").value.should_equal 180
  end
  
  specify "succeeds for an addition" do
    parser.parse("45+4").value.should_equal 49
  end
  
  specify "succeeds for an expression with nested multiplication and addition" do
    parser.parse("(34+(44*(6*(67+(5)))))").value.should_equal 19042
  end
end
=end