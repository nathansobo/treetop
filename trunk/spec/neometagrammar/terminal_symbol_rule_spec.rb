dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the terminal rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:terminal)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses and generates Ruby for a single-quoted string" do
    result = @parser.parse("'foo'")
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == 'foo'
  end
  
  it "successfully parses and generates Ruby for a double-quoted string" do
    result = @parser.parse('"foo"')
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == 'foo'
  end
  
  it "successfully parses and generates Ruby for a single quote inside of double quotes" do
    result = @parser.parse('"\'"')
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == "'"
  end
  
  it "successfully parses and generates Ruby for an escaped single quote inside of single quotes" do
    result = @parser.parse("'\\''")
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == "'"
  end
  
  it "successfully parses and generates Ruby for a double quote inside of single quotes" do
    result = @parser.parse("'\"'")
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == '"'
  end

  it "successfully parses and generates Ruby for an escaped double quote inside of double quotes" do
    result = @parser.parse('"\""')
    result.should be_success
    
    value = eval(result.to_ruby)
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == '"'
  end
end