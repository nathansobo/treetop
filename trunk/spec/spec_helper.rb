dir = File.dirname(__FILE__)
require "#{dir}/../lib/treetop"

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