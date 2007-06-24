module NeometagrammarSpecContextHelper
  unless const_defined?(:Neometagrammar)
    Neometagrammar = MetagrammarBootstrapper.gen_1_neometagrammar
  end
  
  def set_metagrammar_root(new_root_symbol)
    new_root = Neometagrammar.nonterminal_symbol(new_root_symbol)
    @previous_root = Neometagrammar.root
    Neometagrammar.root = new_root
  end
  
  def reset_metagrammar_root
    Neometagrammar.root = @previous_root
  end
  
  def parser_for_metagrammar
    Neometagrammar.new_parser
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
