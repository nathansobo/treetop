dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/test_helper")
require File.expand_path("#{dir}/arithmetic_node_classes")
require File.expand_path("#{dir}/lambda_calculus_node_classes")
load_grammar File.expand_path("#{dir}/arithmetic")
load_grammar File.expand_path("#{dir}/lambda_calculus")

class LambdaCalculusParserTest < Test::Unit::TestCase
  include ParserTestHelper
  
  def setup
    @parser = LambdaCalculusParser.new
  end
  
  def test_free_variable
    assert_equal 'x', parse('x').eval.to_s
  end
  
  def test_variable_binding
    variable = parse('x').eval
    env = variable.bind(1, {})
    assert_equal 1, env['x']
  end
  
  def test_bound_variable_evaluation
    assert_equal 1, parse('x').eval({'x' => 1})
  end
  
  def test_identity_function
    assert_equal '\x[x]', parse('\x[x]').eval.to_s
  end
  
  def test_function_returning_constant_function
    assert_equal '\x[\y[x]]', parse('\x[\y[x]]').eval.to_s
  end
  
  def test_identity_function_application
    assert_equal 1, parse('\x[x] 1').eval
    assert_equal '\y[y]', parse('\x[x] \y[y]').eval.to_s
  end
  
  def test_constant_function_construction
    assert_equal '\y[1]', parse('\x[\y[x]] 1').eval.to_s
  end
  
  def test_multiple_argument_application_is_left_associative
    assert_equal '\b[b]', parse('\x[\y[x y]] \a[a] \b[b]').eval.to_s
  end
  
  def test_parentheses_override_application_order
    assert_equal '\y[\b[b] y]', parse('\x[\y[x y]] (\a[a] \b[b])').eval.to_s
  end
  
  def test_arithmetic_in_function_body
    assert_equal 10, parse('\x[x + 5] 5').eval
  end
  
  def test_addition_of_function_results
    assert_equal 20, parse('\x[x + 5] 5 + \x[15 - x] 5').eval
  end
end
