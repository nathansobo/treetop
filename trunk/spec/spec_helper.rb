$:.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))
require 'treetop'
require 'rubygems'
require 'spec'

module Kernel
  def h(object)
    object.inspect.gsub(/</, '&lt;').gsub(/>/, '&gt;')
  end
  
  def ph(object)
    puts h(object)
  end
end


include Treetop

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
  
  parse_cache_mock = mock('parse cache')
  parse_cache_mock.stub!(:[]).and_return(FakeEmptyNodeCache.new)
  
  parser.stub!(:parse_cache).and_return(parse_cache_mock)
  return parser
end

def parse_success(interval = 0...5)
  SyntaxNode.new(mock('expression'), mock('input'), interval)
end

def parse_success_with_nested_failure_at(failure_index, interval = 0...5)
  nested_failure = TerminalParseFailure.new(mock('terminal expression'), failure_index)
  SyntaxNode.new(mock('expression'), mock('input'), interval, [nested_failure])
end

def parse_failure_at(failure_index = 5)
  ParseFailure.new(failure_index, [])
end

def parse_failure_at_with_nested_failure_at(failure_index = 0, nested_failure_index = 5)
  ParseFailure.new(failure_index, [terminal_parse_failure_at(nested_failure_index)])
end

def terminal_parse_failure_at(index)
  TerminalParseFailure.new(mock('terminal parsing expression'), index)
end