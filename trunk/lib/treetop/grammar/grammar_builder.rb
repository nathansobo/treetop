class GrammarBuilder
  attr_accessor :grammar
  include ParsingExpressionBuilderHelper
  
  def initialize(grammar)
    self.grammar = grammar
  end
  
  def build(&block)
    instance_eval(&block)
  end
      
  def root(sym)
    grammar.root = grammar.nonterminal_symbol(sym)
  end
  
  def rule(nonterminal_name, expression_or_expression_builder)
    nonterminal_symbol = grammar.nonterminal_symbol(nonterminal_name)
    parsing_expression = parsing_expression_for(expression_or_expression_builder)

    grammar.add_parsing_rule(nonterminal_symbol, parsing_expression)
  end
  
  def parsing_expression_for(expression_or_expression_builder)
    case expression_or_expression_builder
    when ParsingExpression
      return expression_or_expression_builder
    when ParsingExpressionBuilder
      expression_or_expression_builder.grammar = grammar
      return expression_or_expression_builder.build
    end
  end
end