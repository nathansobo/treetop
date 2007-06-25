module MetagrammarSpecContextHelper
  unless const_defined?(:Gen1Metagrammar)
    Gen1Metagrammar = MetagrammarBootstrapper.gen_1_metagrammar
  end
  
  def set_metagrammar_root(new_root_symbol)
    new_root = Gen1Metagrammar.nonterminal_symbol(new_root_symbol)
    @previous_root = Gen1Metagrammar.root
    Gen1Metagrammar.root = new_root
  end
  
  def reset_metagrammar_root
    Gen1Metagrammar.root = @previous_root
  end
  
  def parser_for_metagrammar
    Gen1Metagrammar.new_parser
  end
  
  def setup_grammar_constant(name_symbol)
    Object.send(:const_set, name_symbol, Grammar.new(name_symbol))
    grammar_node_mock(name_symbol)
  end
  
  def teardown_grammar_constant(name_symbol)
    Object.send(:remove_const, name_symbol)
  end
  
  def grammar_node_mock(name_symbol = :GrammarNodeMock)
    grammar_node_mock = stub("#{name_symbol} grammar node", :name => name_symbol.to_s)
  end
end
