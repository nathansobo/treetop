module Treetop
  class Metagrammar < Grammar
    def initialize
      super
      build do
        rule :primary, PrimaryBuilder.new        
        rule :nonterminal_symbol, NonterminalSymbolBuilder.new  
        rule :terminal_symbol, TerminalSymbolBuilder.new
        rule :character_class, CharacterClassBuilder.new
        rule :anything_symbol, AnythingSymbolBuilder.new
        rule :sequence, SequenceBuilder.new
        rule :ordered_choice, OrderedChoiceBuilder.new        
        rule :whitespace, one_or_more(char_class(" \t\n\r"))
      end
    end
  end
end
