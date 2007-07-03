module Treetop
  class CompiledParser
        
    attr_reader :input, :index
    
    def self.node_classes
      @node_classes ||= Hash.new
    end
    
    def _rt_prepare_to_parse(input)
      @input = input
      @index = 0
    end
 
    def _rt_parse_char_class(char_class_string, node_class)
      char_class_re = /[#{char_class_string}]/
      if input.index(char_class_re, index) == index
        result = node_class.new(input, index...(index + 1))
        @index += 1
        result
      else
        _rt_terminal_parse_failure("[#{char_class_string}]")
      end
    end
    
    def _rt_parse_terminal(terminal_string, node_class)
      if input.index(terminal_string, index) == index
        result = node_class.new(input, index...(index + terminal_string.length))
        @index += terminal_string.length
        result
      else
        _rt_terminal_parse_failure(terminal_string)
      end
    end
    
    def _rt_parse_failure(start_index, nested_results)
      failure_index = index
      @index = start_index
      ParseFailure.new(failure_index, nested_results)
    end
    
    def _rt_terminal_parse_failure(expected_string)
      TerminalParseFailure.new(index, expected_string)
    end
  end
end