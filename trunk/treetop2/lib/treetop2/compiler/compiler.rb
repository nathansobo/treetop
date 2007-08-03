module Treetop2
  module Compiler
    class ParenthesizedExpression < ::Treetop::SequenceSyntaxNode
      def compile(address, builder)
        elements[2].compile(address, builder)
      end
    end
    
    class Nonterminal < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        use_vars :result
        assign_result "self.send(:_nt_#{text_value})"
      end
    end
    
    class Terminal < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        assign_result "parse_terminal(#{text_value})"
      end
    end
    
    class AnythingSymbol < ::Treetop::TerminalSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        assign_result 'parse_anything'
      end
    end
    
    class CharacterClass < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator

      def compile(address, builder)
        super
        assign_result "parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}')"
      end
    end
    
    class Sequence < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        begin_comment(self)
        use_vars :result, :start_index, :accumulator, :nested_results
        compile_sequence_elements(sequence_elements)
        builder.if__ "#{accumulator_var}.last.success?" do
          assign_result "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var})"
        end
        builder.else_ do
          reset_index
          assign_result "ParseFailure.new(#{start_index_var}, #{accumulator_var})"
        end
        end_comment(self)
      end
      
      def compile_sequence_elements(elements)
        obtain_new_subexpression_address
        elements.first.compile(subexpression_address, builder)
        accumulate_subexpression_result
        if elements.size > 1
          builder.if_ subexpression_success? do
            compile_sequence_elements(elements[1..-1])
          end
        end
      end
    end
    
    class Choice < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        begin_comment(self)
        use_vars :result, :start_index, :nested_results
        compile_alternatives(alternatives)
        end_comment(self)
      end
      
      def compile_alternatives(alternatives)
        obtain_new_subexpression_address
        alternatives.first.compile(subexpression_address, builder)
        accumulate_nested_result
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
          builder << "#{subexpression_result_var}.update_nested_results(#{nested_results_var})"
        end
        builder.else_ do
          if alternatives.size == 1
            reset_index
            assign_result "ParseFailure.new(#{start_index_var}, #{nested_results_var})"
          else
            compile_alternatives(alternatives[1..-1])
          end
        end
      end
    end
    
    
    class Repetition < ::Treetop::TerminalSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, parent_expression, builder)
        super(address, builder)        
        repeated_expression = parent_expression.atomic
        begin_comment(parent_expression)
        use_vars :result, :accumulator, :nested_results, :start_index

        builder.loop do
          obtain_new_subexpression_address
          repeated_expression.compile(subexpression_address, builder)
          accumulate_nested_result
          builder.if__ subexpression_success? do
            accumulate_subexpression_result
          end
          builder.else_ do
            builder.break
          end
        end
      end
      
      def sequence_node
        "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
      end
    end
    
    class ZeroOrMore < Repetition
      def compile(address, parent_expression, builder)
        super(address, parent_expression, builder)
        assign_result sequence_node
        end_comment(parent_expression)
      end
    end
    
    class OneOrMore < Repetition
      def compile(address, parent_expression, builder)
        super(address, parent_expression, builder)
        builder.if__ "#{accumulator_var}.empty?" do
          reset_index
          assign_result "ParseFailure.new(#{start_index_var}, #{nested_results_var})"
        end
        builder.else_ do
          assign_result sequence_node
        end
        end_comment(parent_expression)
      end
    end
    
    class Optional < ::Treetop::SequenceSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, builder)
        super
        use_vars :result
        obtain_new_subexpression_address
        optional_expression.compile(subexpression_address, builder)
        
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
        end
        builder.else_ do
          assign_result epsilon_node
        end
      end
      
      def optional_expression
        elements[0]
      end
    end
    
    class Predicate < ::Treetop::TerminalSyntaxNode
      include ParsingExpressionGenerator

      def compile(address, parent_expression, builder)
        super(address, builder)
        begin_comment(parent_expression)
        use_vars :result, :start_index
        obtain_new_subexpression_address
        parent_expression.predicated_expression.compile(subexpression_address, builder)
        builder.if__(subexpression_success?) { when_success }
        builder.else_ { when_failure }
        end_comment(parent_expression)
      end
      
      def assign_failure
        assign_result "ParseFailure.new(#{start_index_var}, #{subexpression_result_var}.nested_failures)"
      end
      
      def assign_success
        reset_index
        assign_result epsilon_node
      end
    end
    
    class AndPredicate < Predicate
      def when_success
        assign_success
      end

      def when_failure
        assign_failure
      end
    end
    
    class NotPredicate < Predicate
      def when_success
        assign_failure
      end
      
      def when_failure
        assign_success
      end
    end
  end
end