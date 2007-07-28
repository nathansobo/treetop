module Treetop2
  class CompiledParser
    protected
    attr_writer :index
    
    public        
    attr_reader :input, :index
    
    def self.node_classes
      @node_classes ||= Hash.new
    end
    
    def self.subexpression_procs
      @subexpression_procs
    end
    
    def self.clear_subexpression_procs
      @subexpression_procs = Hash.new
    end
    
    def exp
      self.class.subexpression_procs
    end
    
    def prepare_to_parse(input)
      self.class.clear_subexpression_procs
      @input = input
      @index = 0
    end
 
    def parse_char_class(char_class_string, node_class)
      char_class_re = /[#{char_class_string}]/
      if input.index(char_class_re, index) == index
        result = node_class.new(input, index...(index + 1))
        @index += 1
        result
      else
        terminal_parse_failure("[#{char_class_string}]")
      end
    end
    
    def parse_terminal(terminal_string, node_class=TerminalSyntaxNode)
      if input.index(terminal_string, index) == index
        result = node_class.new(input, index...(index + terminal_string.length))
        @index += terminal_string.length
        result
      else
        terminal_parse_failure(terminal_string)
      end
    end
    
    def parse_anything(node_class=TerminalSyntaxNode)
      if index < input.length
        result = node_class.new(input, index...(index + 1))
        @index += 1
        result
      else
        terminal_parse_failure("any character")
      end
    end
    
    def parse_failure(start_index, nested_results)
      failure_index = index
      @index = start_index
      ParseFailure.new(failure_index, nested_results)
    end
    
    def terminal_parse_failure(expected_string)
      TerminalParseFailure.new(index, expected_string)
    end
    
  end
end