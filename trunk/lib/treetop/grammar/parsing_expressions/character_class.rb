module Treetop
  class CharacterClass < TerminalSymbol
    attr_reader :char_class_string
    
    def initialize(char_class_string)
      super('')
      @char_class_string = char_class_string
      self.prefix_regex = Regexp.new("^[#{char_class_string}]")
    end
    
    def to_s
      return "[#{char_class_string}]"
    end 
  end
end