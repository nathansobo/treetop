module Treetop
  class Metagrammar < Grammar
    def initialize
      super
      build do
        rule :grammar, MetagrammarBuilder.new
        rule :parsing_rule_sequence, ParsingRuleSequenceBuilder.new        
        rule :parsing_rule, ParsingRuleBuilder.new
        rule :ordered_choice, OrderedChoiceBuilder.new
        rule :sequence, SequenceBuilder.new
        rule :primary, PrimaryBuilder.new
        rule :prefix, PrefixBuilder.new
        rule :suffix, SuffixBuilder.new
        rule :nonterminal_symbol, NonterminalSymbolBuilder.new  
        rule :terminal_symbol, TerminalSymbolBuilder.new
        rule :character_class, CharacterClassBuilder.new
        rule :anything_symbol, AnythingSymbolBuilder.new
        rule :node_class_eval_block, NodeClassEvalBlockBuilder.new
        rule :space, one_or_more(char_class(" \t\n\r"))
        rule :keyword, choice('rule', 'end')
      end
    end
  end
end
