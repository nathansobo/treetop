require 'test/unit'
require 'rubygems'
require 'treetop'

module ParserTestHelper
  def assert_evals_to_self(input)
    assert_evals_to(input, input)
  end
  
  def assert_evals_to(expected, input)
    result = @parser.parse(input)
    if result.failure?
      puts result.nested_failures
    end
    assert_equal expected, result.eval.to_s
  end
  
  def assert_parse_success(input)
    result = @parser.parse(input)
    if result.failure?
      puts result.nested_failures
    end
    assert @parser.parse(input).success?
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