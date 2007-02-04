module Treetop
  class CharacterClass < TerminalSymbol
    def initialize(char_class_string)
      super('')
      self.prefix_regex = Regexp.new("[#{char_class_string}]")
    end
  end
end