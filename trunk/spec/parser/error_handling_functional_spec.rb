require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A parser a grammar describing one or more characters followed by semicolons surrounded by braces" do
  
  before do
    @grammar_parser = Metagrammar.new_parser
    result = @grammar_parser.parse("""grammar
                                        rule brace_thingy
                                          '{' (. ';')+  '}'
                                        end
                                      end""")
    grammar = result.value
    @parser = grammar.new_parser
  end
  
  it "parses input matching the grammar successfully" do
    @parser.parse("{a;b;c;}").should be_success
  end
  
  it " should yield an error related to a missing semicolon if it is missing" do
    result = @parser.parse("{a;b;c}")
    result.should be_failure
    nested_failures = result.nested_failures
    nested_failures.size.should == 1
    nested_failures.first.expression.prefix.should == ';'
  end
end