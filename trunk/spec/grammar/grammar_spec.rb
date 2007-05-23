dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A new grammar" do
  before do
    @grammar = Grammar.new
  end

  it "returns an instance of Parser in response to new_parser" do
    @grammar.new_parser.should be_an_instance_of(Parser)
  end
  
  it "returns unique parsers in response to repeated calls to new_parser" do
    @grammar.new_parser.should be_an_instance_of(Parser)
  end
  
  it "returns parsers that retain a reference to that grammar" do
    @grammar.new_parser.grammar.should == @grammar
  end
  
  it "retains an explicitly set root even if the first parsing rule is added " +
          "subsequently to it being set" do
    alt_root = mock("Alternate root nonterminal")
    @grammar.root = alt_root
    @grammar.root.should == alt_root
    @grammar.add_parsing_rule(make_parsing_rule)
    @grammar.root.should == alt_root
  end
  
  it "constructs or returns a previously constructed a nonterminal symbol " +
          "with a reference to itself on call to nonterminal_symbol" do
    ruby_sym = :foo
    nonterminal = @grammar.nonterminal_symbol(ruby_sym)
    nonterminal.grammar.should == @grammar
    @grammar.nonterminal_symbol(ruby_sym).should == nonterminal
  end
  
  it "constructs a parsing rule automatically if add_parsing_rule is called with " +
          "a nonterminal symbol and a parsing expression" do
    ruby_sym = :foo
    nonterminal = @grammar.nonterminal_symbol(ruby_sym)
    expression = TerminalSymbol.new("foo")
    @grammar.add_parsing_rule(nonterminal, expression)
    @grammar.get_parsing_expression(nonterminal).should == expression
  end
  
  it "has a builder" do
    @grammar.builder.should_not be_nil
  end

  it "assigns the builders grammar to itself" do
    @grammar.builder.grammar.should == @grammar
  end

  it "proxies calls to #build to its associated builder" do
    @grammar.builder.should_receive(:foo)
    @grammar.build do
      foo
    end
  end
  
  it "raises an exception if a nonexistent rule is accessed" do
    lambda do
      @grammar.get_parsing_expression(@grammar.nonterminal_symbol(:nonexistent))
    end.should raise_error
  end
end

describe "The Grammar class" do
  it "calls build on a new instance with a block if it is provided to #new" do
    builder_mock = mock("builder")
    GrammarBuilder.should_receive(:new).and_return(builder_mock)
    builder_mock.should_receive(:build)
    Grammar.new { }
  end
  
  it "does not call build on a new instance if no block is provided to #new" do
    builder_mock = mock("builder")
    GrammarBuilder.should_receive(:new).and_return(builder_mock)
    builder_mock.should_not_receive(:build)
    Grammar.new
  end
end

describe "A grammar with a parsing rule" do
  before do
    @grammar = Grammar.new
    @rule = make_parsing_rule
    @grammar.add_parsing_rule(@rule)
  end
  
  it "can retrive the parsing expression associated with that rule based on " +
          "its nonterminal symbol" do
    @grammar.get_parsing_expression(@rule.nonterminal_symbol).should == @rule.parsing_expression
  end
  
  it "is rooted at that parsing rule's nonterminal because it was the first " +
          "added and no root was explicitly set" do
    @grammar.root.should == @rule.nonterminal_symbol
  end
  
  it "is rooted at a different root if one is explicitly set" do
    alt_root = mock("Alternate root nonterminal")
    @grammar.root = alt_root
    @grammar.root.should == alt_root
  end
end

describe "A Grammar instantiated with a name" do
  before do
    @name = 'Foo'
    @grammar = Grammar.new(@name)
  end
  
  it "retains its name" do
    @grammar.name.should == @name
  end
end

def make_parsing_rule
  nonterminal = NonterminalSymbol.new(:foo, @grammar)
  ParsingRule.new(nonterminal, mock("Parsing expression"))
end