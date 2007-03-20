module Treetop
  class MetagrammarBuilder < ParsingExpressionBuilder
    def build
      seq('grammar', :space, grammar_name, :parsing_rule_sequence, optional(:space), 'end') do
        def value
          Grammar.new
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