module Treetop
  class Protometagrammar
    class TrailingBlockExpressionBuilder < ParsingExpressionBuilder
      def build
        choice(trailing_block, nothing)
      end
    
      def trailing_block
        seq(:space, :node_class_eval_block) do
          def value(parsing_expression)
            parsing_expression.node_class_eval(node_class_eval_block.value)
            return parsing_expression
          end

          def node_class_eval_block
            elements[1]
          end
        end
      end
    
      def nothing
        exp('') do
          def value(parsing_expression)
            parsing_expression
          end
        end
      end
    end
  end
end