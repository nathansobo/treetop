module Treetop2
  module Compiler
    class ParenthesizedExpression < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, builder)
        elements[2].compile(lexical_address, builder)
      end
    end
    
    class TerminalExpression < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, builder)
        builder.assign_result lexical_address, "parse_terminal(#{text_value})"
      end
    end
    
    class AnythingSymbol < ::Treetop::TerminalSyntaxNode
      def compile(lexical_address, builder)
        builder.assign_result lexical_address, 'parse_anything'
      end
    end
    
    class CharacterClass < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, builder)
        builder.assign_result lexical_address, "parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}')"
      end
    end
    
    class Sequence < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, builder)
        results_accumulator_var = "s#{lexical_address}"
        start_index_var = "i#{lexical_address}"
        
        builder.begin_comment(self)
        builder.assign [results_accumulator_var, start_index_var], ['[]', 'index']
        compile_sequence_elements(sequence_elements, results_accumulator_var, builder)
        builder.if__ "#{results_accumulator_var}.last.success?" do
          builder.assign_result lexical_address, "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{results_accumulator_var})"
        end        
        builder.else_ do
          builder.reset_index(start_index_var)
          builder.assign_result lexical_address, "ParseFailure.new(#{start_index_var}, #{results_accumulator_var})"
        end
        builder.end_comment(self)
      end
              
      def compile_sequence_elements(elements, results_accumulator_var, builder)
        result_address = builder.next_address
        result_var = "r#{result_address}"
        
        elements.first.compile(result_address, builder)
        builder.accumulate results_accumulator_var, result_var
        if elements.size > 1          
          builder.if_ "#{result_var}.success?" do
            compile_sequence_elements(elements[1..-1], results_accumulator_var, builder)
          end
        end
      end
    end
    
    class Choice < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, builder)
        result_var = "r#{lexical_address}"
        start_index_var = "i#{lexical_address}"
        nested_results_accumulator = "nr#{lexical_address}"
        
        builder.begin_comment(self)
        builder.assign [nested_results_accumulator, start_index_var], ['[]', 'index']
        compile_alternatives(alternatives, result_var, start_index_var, nested_results_accumulator, builder)
        builder.end_comment(self)
      end
      
      def compile_alternatives(alternatives, choice_result_var, choice_start_index, nested_results_accumulator, builder)
        alternative_result_address = builder.next_address
        alternative_result_var = "r#{alternative_result_address}"
        
        alternatives.first.compile(alternative_result_address, builder)
        builder.accumulate nested_results_accumulator, alternative_result_var
        
        builder.if__ "#{alternative_result_var}.success?" do
          builder.assign choice_result_var, alternative_result_var
          builder << "#{choice_result_var}.update_nested_results(#{nested_results_accumulator})"
        end
        builder.else_ do
          if alternatives.size == 1
            builder.reset_index(choice_start_index)
            builder.assign choice_result_var, "ParseFailure.new(#{choice_start_index}, #{nested_results_accumulator})"
          else
            compile_alternatives(alternatives[1..-1], choice_result_var, choice_start_index, nested_results_accumulator, builder)
          end
          
        end
      end
    end
    
  
    
    class Repetition < ::Treetop::TerminalSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, repeated_expression, builder)
        super(address, builder)
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
    end
    
    class ZeroOrMore < Repetition
      def compile(lexical_address, parent_expression, builder)
        builder.begin_comment(parent_expression)
        super(lexical_address, parent_expression.atomic, builder)
        assign_result "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
        builder.end_comment(parent_expression)
      end
    end
    
    class OneOrMore < Repetition
      def compile(lexical_address, parent_expression, builder)
        builder.begin_comment(parent_expression)
        super(lexical_address, parent_expression.atomic, builder)
        builder.if__ "#{accumulator_var}.empty?" do
          reset_index
          assign_result "ParseFailure.new(#{start_index_var}, #{nested_results_var})"
        end
        builder.else_ do
          assign_result "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
        end
        builder.end_comment(parent_expression)
      end
    end
  end
end