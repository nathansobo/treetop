require 'test/unit'
require 'rubygems'
require 'treetop'

dir = File.dirname(__FILE__)
load_grammar File.expand_path("#{dir}/lambda_calculus")

class LambdaCalculusParserTest < Test::Unit::TestCase  
  def setup
    @parser = LambdaCalculusParser.new
  end
  
  def test_free_variable
    assert_evals_to_self 'x'
  end
  
  def test_variable_binding
    variable = @parser.parse('x').eval
    env = variable.bind(1, {})
    assert_equal 1, env['x']
  end
  
  def test_bound_variable
    result = @parser.parse('x')
    assert_equal 1, result.eval({'x' => 1})
  end
  
  def test_identity_function
    assert_evals_to '\x[x] {}', '\x[x]'
  end
  
  def test_function_returning_constant_function
    assert_evals_to '\x[\y[x]] {}', '\x[\y[x]]'
  end
  
  def test_identity_function_application
    assert_evals_to 'y', '\x[x] y'
    assert_evals_to '\y[y] {}', '\x[x] \y[y]'
  end
  
  def test_multiple_argument_application
    assert_evals_to 'x', '\x[\y[x y]] \a[a] x'
  end
  
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
end
