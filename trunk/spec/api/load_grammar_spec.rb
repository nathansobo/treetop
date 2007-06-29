dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An environment in which a test grammar has been loaded via load_grammar" do
  
  before do
    load_grammar "#{dir}/test"
  end
  
  after do
    Object.send(:remove_const, Test.name)
  end

  it "has the test grammar assigned to a Test constant in Object" do
    ::Test.should be_an_instance_of(Grammar)
    ::Test.new_parser.parse('bar').should be_success
  end
end