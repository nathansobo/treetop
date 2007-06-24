dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the space rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:space)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses different types of whitespace" do
    @parser.parse(' ').should be_success
    @parser.parse('    ').should be_success
    @parser.parse("\t\t").should be_success
    @parser.parse("\n").should be_success
  end
  
  it "does not parse nonwhitespace characters" do
    @parser.parse('g').should be_failure
    @parser.parse('g ').should be_failure
    @parser.parse(" crack\n").should be_failure  
    @parser.parse("\n rule foo\n bar\n end\n").should be_failure
  end
end