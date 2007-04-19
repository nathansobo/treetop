dir = File.dirname(__FILE__)
require File.expand_path('treetop', "#{dir}/../lib/")

include Treetop

def h(text)
  text.inspect.gsub(/</, '&lt;').gsub(/>/, '&gt;')
end

class FakeEmptyNodeCache
  def [](parsing_expression)
    nil
  end
    
  def store(syntax_node)
    syntax_node
  end
end

def parser_with_empty_cache_mock
  parser = mock("parser with empty cache")
  parser.stub!(:node_cache_for).and_return(FakeEmptyNodeCache.new)
  return parser
end

def successful_parse_result_for(succeeding_expression, interval = 0...5)
  value = SyntaxNode.new(mock('input'), interval)
  SuccessfulParseResult.new(succeeding_expression, value, [])
end


def successful_parse_result_with_failure_tree_for(succeeding_expression, interval = 0...5)
  value = SyntaxNode.new(mock('input'), interval)
  failing_subexpression = mock('failing subexpression')
  failure_subtree = FailureLeaf.new(failing_subexpression, interval.end + 5)
  SuccessfulParseResult.new(succeeding_expression, value, [failure_subtree])
end

def failed_parse_result_for(failing_expression, failure_index = 5)
  FailedParseResult.new(failing_expression, failure_index, [])
end