module MetagrammarSpecContextHelper
  def parse_result_for(input)
    grammar = Grammar.new
    result = @parser.parse(input)

    if result.failure?
      return result
    else
      result.value(grammar)
    end
  end
  
  def with_both_protometagrammar_and_metagrammar(nonterminal_symbol = nil)
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(nonterminal_symbol || @root) if nonterminal_symbol || @root
    yield
    
    @metagrammar = Metagrammar
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(nonterminal_symbol || @root) if nonterminal_symbol || @root    
    yield
  end
end
