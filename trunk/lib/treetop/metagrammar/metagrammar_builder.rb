module Treetop
  class MetagrammarBuilder < ParsingExpressionBuilder
    def build
      seq('grammar', :space, optional(seq(grammar_name, :space)), 'end') do
        def value
          Grammar.new
        end
      end
    end
    
    def grammar_name
      seq(char_class('A-Z'), zero_or_more(char_class('a-z0-9_')))
    end
  end
end