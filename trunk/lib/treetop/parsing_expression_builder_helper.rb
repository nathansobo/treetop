module ParsingExpressionBuilderHelper
  attr_accessor :grammar
  
  def nonterm(sym)
    grammar.nonterminal_symbol(sym)
  end
end