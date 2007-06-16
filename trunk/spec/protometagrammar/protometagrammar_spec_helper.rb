require "#{TREETOP_ROOT}/protometagrammar"

module ProtometagrammarSpecContextHelper
  def parse_result_for(parser, input)
    grammar = Grammar.new
    result = parser.parse(input)

    result.should_not be_failure
    result.value(grammar)
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
end
