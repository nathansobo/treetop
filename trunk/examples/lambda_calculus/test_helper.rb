require 'test/unit'
require 'rubygems'
require 'treetop'

module ParserTestHelper
  def assert_evals_to_self(input)
    assert_evals_to(input, input)
  end
  
  def parse(input)
    result = @parser.parse(input)
    if result.failure?
      puts result.nested_failures.join("\n")
    end
    assert result.success?
    result
  end
end