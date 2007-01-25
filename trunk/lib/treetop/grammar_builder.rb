class GrammarBuilder
  attr_accessor :grammar
  
  def initialize(grammar)
    self.grammar = grammar
  end
  
  def build(&block)
    instance_eval(&block)
  end
      
  def root(sym)
    grammar.root = grammar.nonterminal_symbol(sym)
  end
  
  def rule(name, builder_class)
    nonterminal_symbol = grammar.nonterminal_symbol(name)
    
    builder = builder_class.new
    parsing_expression = builder.build
    
    grammar.add_parsing_rule(nonterminal_symbol, parsing_expression)
  end
end