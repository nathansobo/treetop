module MetagrammarSpecContextHelper
  def parse_result_for(parser, grammar_name, input)
    result = parser.parse(input)
    result.should_not be_failure
    eval(result.to_ruby(grammar_node_mock(grammar_name)))
  end
  
  def with_both_protometagrammar_and_metagrammar(root_sym, &block)
    with_protometagrammar(root_sym, &block)
    with_metagrammar(root_sym, &block)
  end
  
  def with_protometagrammar(root_sym)
    metagrammar = Protometagrammar.new
    root = metagrammar.nonterminal_symbol(root_sym)
    previous_root = metagrammar.root    
    metagrammar.root = root
    parser = metagrammar.new_parser
    yield(parser)
    metagrammar  
  end
  
  def with_metagrammar(root_sym)
    root = Metagrammar.nonterminal_symbol(root_sym)
    previous_root = Metagrammar.root
    Metagrammar.root = root
    parser = Metagrammar.new_parser
    yield(parser)
    Metagrammar.root = previous_root
  end
  
  def grammar_node_mock(name = "MockGrammar")
    stub("grammar_node", :name => name)
  end
end
