module MetagrammarSpecContextHelper
  
  module Test
    # evaluate the Metagrammar under test inside Test module to distinguish it
    # from the Metagrammar currently supporting the rest of the system
    unless const_defined?(:Metagrammar)
      module_eval MetagrammarBootstrapper.metagrammar_ruby
    end  
  end
  
  def set_metagrammar_root(new_root_symbol)
    new_root = Test::Treetop::Metagrammar.nonterminal_symbol(new_root_symbol)
    @previous_root = Test::Treetop::Metagrammar.root
    Test::Treetop::Metagrammar.root = new_root
  end
  
  def reset_metagrammar_root
    Test::Treetop::Metagrammar.root = @previous_root
  end
  
  def parser_for_metagrammar
    Test::Treetop::Metagrammar.new_parser
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
