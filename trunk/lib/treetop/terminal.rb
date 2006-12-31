dir = File.dirname(__FILE__)
require "#{dir}/parse_result"

module Treetop
  class Terminal
    attr_accessor :prefix, :prefix_regex
  
    def terminal?
      true
    end
  
    def nonterminal?
      false
    end
  
    def initialize(prefix)
      self.prefix = prefix
      self.prefix_regex = /^#{Regexp.escape(prefix)}/
    end
  
    def parse_at(start, buffer, parser_instance)
      puts self if start.nil?
      match = prefix_regex.match(buffer[start..(buffer.length)])
      if match
        return ParseResult.new(match[0], start, start + match.end(0))
      else
        return ParseResult.new_failure(start)
      end
    end
  end
end