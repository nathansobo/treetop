module Treetop
  class BlockExpressionBuilder < ParsingExpressionBuilder
    def build
      seq('{', zero_or_more(choice(:node_class_eval_block, anything_but_a_brace)), '}') do
        def value
          elements[1].text_value
        end
      end
    end
    
    def anything_but_a_brace
      seq(notp(choice('{', '}')), any)
    end
  end
end