require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A parser for a grammar that contains only atomic symbols" do
  setup do
    @grammar = Grammar.new
    
    terminal = TerminalSymbol.new("bar")
    nonterminal = NonterminalSymbol.new(:foo, @grammar)
    parse_rule = ParsingRule.new(nonterminal, terminal)
    
    @grammar.add_parsing_rule(parse_rule)
    @parser = @grammar.new_parser
  end
  
  specify "returns a kind of SyntaxNode upon a successful parse" do
    input = "bar"
    @parser.parse(input).should_be_a_kind_of(SyntaxNode)
  end
  
  specify "returns a SyntaxNode with a text value equal to the input upon a successful parse" do
    input = "bar"
    @parser.parse(input).text_value.should_eql input
  end
end

context "A parser for a simple arithmetic grammar" do
  setup do
    @grammar = Grammar.new
    
    additive = @grammar.nonterminal_symbol(:additive)
    multitive = @grammar.nonterminal_symbol(:multitive)
    primary = @grammar.nonterminal_symbol(:primary)
    decimal = @grammar.nonterminal_symbol(:decimal)
    nonzero_digit = @grammar.nonterminal_symbol(:nonzero_digit)
    digit = @grammar.nonterminal_symbol(:digit)
    
    # additive <= multitive "+" additive / multitive
    additive_exp = OrderedChoice.new([Sequence.new([multitive, TerminalSymbol.new("+"), additive]),
                                      multitive])
    @grammar.add_parsing_rule(additive, additive_exp)
    
    # multitive <= primary "*" multitive / primary
    multitive_exp = OrderedChoice.new([Sequence.new([primary, TerminalSymbol.new("*"), multitive]),
                                      primary])
    @grammar.add_parsing_rule(multitive, multitive_exp)
    
    # primary <= "(" additive ")" / decimal
    primary_exp = OrderedChoice.new([Sequence.new([TerminalSymbol.new("("), additive, TerminalSymbol.new(")")]),
                                     decimal])
    @grammar.add_parsing_rule(primary, primary_exp)
    
    # decimal <= nonzero_digit digit* / "0"
    decimal_exp = OrderedChoice.new([Sequence.new([nonzero_digit, ZeroOrMore.new(digit)]),
                                     TerminalSymbol.new("0")])
    @grammar.add_parsing_rule(decimal, decimal_exp)
    
    # nonzero_digit <= 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9
    nonzero_digit_exp = OrderedChoice.new((1..9).collect { |d| TerminalSymbol.new(d.to_s) })
    @grammar.add_parsing_rule(nonzero_digit, nonzero_digit_exp)
    
    # digit <= 0 / 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9
    digit_exp = OrderedChoice.new((0..9).collect { |d| TerminalSymbol.new(d.to_s) })
    @grammar.add_parsing_rule(digit, digit_exp)
    
    @parser = @grammar.new_parser
  end
  
  specify "succeeds for a single digit decimal" do
    @parser.parse("5").should_be_success
  end
  
  specify "succeeds for a multi-digit decimal" do
    @parser.parse("5346").should_be_success
  end
  
  specify "fails for a multi-digit decimal that begins with zero" do
    @parser.parse("05346").should_be_failure
  end
  
  specify "fails for a multi-digit decimal that ends with characters" do
    @parser.parse("05346xs").should_be_failure
  end
  
  specify "succeeds for a parenthesized decimal" do
    @parser.parse("(53)").should_be_success
  end
  
  specify "fails for a partially partially decimal" do
    @parser.parse("(53").should_be_failure
  end
  
  specify "succeeds for a multiplication" do
    @parser.parse("45*4").should_be_success
  end
  
  specify "fails for a partial multiplication" do
    @parser.parse("53*").should_be_failure
  end
  
  specify "succeeds for an addition" do
    @parser.parse("45+4").should_be_success
  end
  
  specify "succeeds for an expression with nested multiplication and addition" do
    @parser.parse("(34+(44*(6*(67+(5)))))").should_be_success
  end
end