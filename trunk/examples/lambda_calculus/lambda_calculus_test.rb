dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/test_helper")
require File.expand_path("#{dir}/arithmetic_node_classes")
load_grammar File.expand_path("#{dir}/arithmetic")
load_grammar File.expand_path("#{dir}/lambda_calculus")

class LambdaCalculusParserTest < Test::Unit::TestCase
  include ParserTestHelper
  
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
  
  def test_parentheses
    puts parse('\a[\b[a]] \c[c] d').eval
  end
  
  # def test_arithmetic_expression_as_body
  #   assert_equal 10, parse('\x[x + 5] 5').eval
  # end
  # 
  # def test_precedence_of_prefix_vs_infix_application
  #   assert_equal 13, parse('\x[x * 5] 2 + 3').eval
  # end  
end
