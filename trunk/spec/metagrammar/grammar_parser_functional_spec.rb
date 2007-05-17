require 'rubygems'
require 'spec'


dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
=begin
describe "An arithmetic grammar defined via the parsing of arithmetic.treetop" do
  setup do
    Arithmetic = parse_grammar("#{dir}/arithmetic")
  end
  
  it "is an instance of Grammar" do
    Arithmetic.should be_an_instance_of Grammar
  end
end

describe "A parser for an arithmetic grammar defined via a file" do
  setup do
    Arithmetic = parse_grammar("#{dir}/arithmetic")
    parser = Arithmetic.new_parser
  end
  
  it "returns a result has the correct value for a digit" do
    parser.parse("5").value.should equal 5
  end
  
  it "succeeds for a multi-digit decimal" do
    parser.parse("5346").value.should equal 5346
  end
    
  it "succeeds for a parenthesized decimal" do
    parser.parse("(53)").value.should equal 53
  end
  
  it "succeeds for a multiplication" do
    parser.parse("45*4").value.should equal 180
  end
  
  it "succeeds for an addition" do
    parser.parse("45+4").value.should equal 49
  end
  
  it "succeeds for an expression with nested multiplication and addition" do
    parser.parse("(34+(44*(6*(67+(5)))))").value.should equal 19042
  end
end
=end