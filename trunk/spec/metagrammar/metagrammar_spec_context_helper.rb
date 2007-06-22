module MetagrammarSpecContextHelper
    
  def parse_result_for(parser, grammar_name, input)
    result = parser.parse(input)
    result.should_not be_failure
    eval(result.to_ruby(grammar_node_mock(grammar_name)))
  end
  
  def with_metagrammar(root_sym, &block)
    with_grammar(Metagrammar, root_sym, &block)
  end
  
  def with_grammar(grammar, root_sym)
    root = grammar.nonterminal_symbol(root_sym)
    previous_root = grammar.root
    grammar.root = root
    parser = grammar.new_parser

    yield(parser)

    grammar.root = previous_root
  end
  
  def grammar_node_mock(name = "MockGrammar")
    stub("grammar_node", :name => name)
  end
end
