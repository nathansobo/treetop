module Treetop
  class GrammarExpressionBuilder < ParsingExpressionBuilder
    def build
      seq('grammar', :space, grammar_name, :parsing_rule_sequence, optional(:space), 'end') do
        def value
          grammar = Grammar.new
          parsing_rules(grammar).each do |parsing_rule|
            grammar.add_parsing_rule(parsing_rule)
          end
          return grammar
        end
        
        def parsing_rules(grammar)
          elements[3].value(grammar)
        end
      end
    end
    
    def grammar_name
      optional(
        seq(char_class('A-Z'),
            zero_or_more(char_class('a-z0-9_')),
            :space))
    end
  end
end