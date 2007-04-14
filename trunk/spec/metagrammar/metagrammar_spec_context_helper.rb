module MetagrammarSpecContextHelper
  def parse_result_for(parser, input)
    grammar = Grammar.new
    result = parser.parse(input)

    result.should_not be_failure
    result.value(grammar)
  end
  
  def with_both_protometagrammar_and_metagrammar(root_sym)
    metagrammar = Protometagrammar.new
    root = metagrammar.nonterminal_symbol(root_sym)
    previous_root = metagrammar.root    
    metagrammar.root = root
    parser = metagrammar.new_parser
    yield(parser)
    metagrammar
    
    root = Metagrammar.nonterminal_symbol(root_sym)
    previous_root = Metagrammar.root
    Metagrammar.root = root
    parser = Metagrammar.new_parser
    yield(parser)
    Metagrammar.root = previous_root
  end
end
