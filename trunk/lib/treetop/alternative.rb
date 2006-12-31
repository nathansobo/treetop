dir = File.dirname(__FILE__)
require "#{dir}/terminal"

module Treetop
  class Alternative
    attr_accessor :containing_nonterminal
    
    def initialize(child_symbols)
      @child_symbols = child_symbols
    end
  
    def children
      rules_for(@child_symbols)
    end
  
    def parse_at(start, buffer, parser_instance)
      raise "Must be contained by a nonterminal" if containing_nonterminal.nil?
      values = []
      next_index = start
      children.each do |child_node|
        parse_result = child_node.parse_at(next_index, buffer, parser_instance)
        if parse_result.value
          values << parse_result.value
          next_index = parse_result.end_index
        else
          return ParseResult.new_failure(start)
        end
      end
      return ParseResult.new(values, start, next_index)
    end
  
    def def_exclusive_methods(&block)
      @exclusive_methods_module = Module.new &block
    end
  
    def exclusive_methods_module
      @exclusive_methods_module or Module.new
    end
  
    private
    def rules_for(child_symbols)
      child_symbols.collect do |child_sym|
        case child_sym
        when Symbol
          containing_nonterminal.get_sibling(child_sym)
        when String
          terminal_for(child_sym)
        else
          puts child_sym.class
        end
      end
    end
  
    def terminal_for(prefix)
      Terminal.new(prefix)
    end
  end
end