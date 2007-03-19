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
end
