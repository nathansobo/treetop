class MalformedGrammarException < Exception
  attr_reader :errors
  
  def initialize(errors)
    @errors = errors
    expected_expressions = errors.collect(&:expression)
    super("String matching #{expected_expressions.join(' or ')} expected at position #{errors.first.index}.")
  end
end