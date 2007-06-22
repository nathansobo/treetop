dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "In only the Metagrammar, the node returned by the suffix rule's successful parsing of the '+' character" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:suffix) do |parser|
      @node = parser.parse("+")
    end
  end

  it "has a Ruby representation that correctly constructs one or more of a parsing expression that precedes the '+' character" do
    preceding_expression_ruby = "TerminalSymbol.new('foo')"
    @node.to_ruby(preceding_expression_ruby).should == "OneOrMore.new(#{preceding_expression_ruby})"
  end
end

describe "The node returned by the suffix rule's successful parsing of the '*' character" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:suffix) do |parser|
      @node = parser.parse("*")
    end
  end

  it "has a Ruby representation that correctly constructs one or more of a parsing expression that precedes the '+' character" do
    preceding_expression_ruby = "TerminalSymbol.new('foo')"
    @node.to_ruby(preceding_expression_ruby).should == "ZeroOrMore.new(#{preceding_expression_ruby})"
  end
end

describe "The node returned by the suffix rule's successful parsing of the '*' character" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:suffix) do |parser|
      @node = parser.parse("?")
    end
  end

  it "has a Ruby representation that correctly constructs one or more of a parsing expression that precedes the '?' character" do
    preceding_expression_ruby = "TerminalSymbol.new('foo')"    
    @node.to_ruby(preceding_expression_ruby).should == "Optional.new(#{preceding_expression_ruby})"
  end
end