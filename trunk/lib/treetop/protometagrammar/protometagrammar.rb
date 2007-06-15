module Treetop
  class Protometagrammar < Grammar
    def initialize
      super
      build do
        rule :grammar, GrammarExpressionBuilder.new
        rule :parsing_rule_sequence, ParsingRuleSequenceExpressionBuilder.new        
        rule :parsing_rule, ParsingRuleExpressionBuilder.new
        rule :ordered_choice, OrderedChoiceExpressionBuilder.new
        rule :sequence, SequenceExpressionBuilder.new
        rule :primary, PrimaryExpressionBuilder.new
        rule :prefix, PrefixExpressionBuilder.new
        rule :suffix, SuffixExpressionBuilder.new
        rule :nonterminal_symbol, NonterminalSymbolExpressionBuilder.new  
        rule :terminal_symbol, TerminalSymbolExpressionBuilder.new
        rule :character_class, CharacterClassExpressionBuilder.new
        rule :anything_symbol, AnythingSymbolExpressionBuilder.new
        rule :block, BlockExpressionBuilder.new
        rule :trailing_block, TrailingBlockExpressionBuilder.new
        rule :space, one_or_more(char_class(" \t\n\r"))
        rule :keyword, KeywordExpressionBuilder.new
      end
    end
  end
end
