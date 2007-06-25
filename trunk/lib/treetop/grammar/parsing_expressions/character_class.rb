module Treetop
  class CharacterClass < TerminalParsingExpression

    attr_reader :char_class_string, :prefix_regex
    
    def initialize(char_class_string)
      super()
      @char_class_string = char_class_string
      @prefix_regex = Regexp.new("[#{char_class_string}]")
    end
    
    def parse_at(input, start_index, parser)
      if input.index(prefix_regex, start_index) == start_index
        return node_class.new(input, start_index...(start_index + 1))
      else
        TerminalParseFailure.new(self, start_index)
      end
    end
    
    def to_s
      return "[#{char_class_string}]"
    end 
  end
end