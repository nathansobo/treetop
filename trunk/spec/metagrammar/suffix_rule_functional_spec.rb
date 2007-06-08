dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the suffix rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :suffix
  end

  it "parses a * to a node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('*')
    
      parsing_expression = mock('expression preceding the suffix')
      zero_or_more = mock('zero or more of the parsing expression')
      parsing_expression.should_receive(:zero_or_more).and_return(zero_or_more)
    
      result.value(parsing_expression).should == zero_or_more
    end
  end

  it "parses a + node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('+')
    
      parsing_expression = mock('expression preceding the suffix')
      one_or_more = mock('one or more of the parsing expression')
      parsing_expression.should_receive(:one_or_more).and_return(one_or_more)
    
      result.value(parsing_expression).should == one_or_more
    end
  end

  it "parses a ? node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('?')
    
      parsing_expression = mock('expression preceding the suffix')
      optional = mock('optional parsing expression')
      parsing_expression.should_receive(:optional).and_return(optional)
    
      result.value(parsing_expression).should == optional
    end
  end
end

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

describe "In only the Metagrammar, the node returned by the suffix rule's successful parsing of the '*' character" do
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

describe "In only the Metagrammar, the node returned by the suffix rule's successful parsing of the '*' character" do
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