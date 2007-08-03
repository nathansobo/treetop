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
    
    module ParsingExpressionGenerator
      attr_reader :address, :builder, :subexpression_address, :var_symbols
      
      def compile(address, builder)
        @address = address
        @builder = builder
      end
      
      def use_vars(*var_symbols)
        @var_symbols = var_symbols
        builder << var_initialization
      end
      
      def result_var
        var(:result)
      end
      
      def accumulator_var
        var(:accumulator)
      end
      
      def nested_results_var
        var(:nested_results)
      end
      
      def start_index_var
        var(:start_index)
      end
      
      def subexpression_result_var
        "r#{subexpression_address}"
      end
      
      def subexpression_success?
        subexpression_result_var + ".success?"
      end
      
      def new_subexpression_address
        @subexpression_address = builder.next_address
      end
      
      def var_initialization
        left, right = [], []
        var_symbols.each do |symbol|
          if init_value(symbol)
            left << var(symbol)
            right << init_value(symbol)
          end
        end
        left.join(', ') + ' = ' + right.join(', ')
      end
      
      def var(var_symbol)
        case var_symbol
        when :result then "r#{address}"
        when :accumulator then "s#{address}"
        when :nested_results then "nr#{address}"
        when :start_index then "i#{address}"
        else raise "Unknown var symbol #{var_symbol}."
        end
      end
      
      def init_value(var_symbol)
        case var_symbol
        when :accumulator, :nested_results then '[]'
        when :start_index then 'index'
        else nil
        end
      end
    end
    
    class Repetition < ::Treetop::TerminalSyntaxNode
      include ParsingExpressionGenerator
      
      def compile(address, repeated_expression, builder)
        super(address, builder)
        use_vars :result, :accumulator, :nested_results, :start_index
        builder.loop do
          new_subexpression_address
          repeated_expression.compile(subexpression_address, builder)
          builder.accumulate nested_results_var, subexpression_result_var
          builder.if__ subexpression_success? do
            builder.accumulate accumulator_var, subexpression_result_var
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
        builder.assign result_var, "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
        builder.end_comment(parent_expression)
      end
    end
    
    class OneOrMore < Repetition
      def compile(lexical_address, parent_expression, builder)
        builder.begin_comment(parent_expression)
        super(lexical_address, parent_expression.atomic, builder)
        builder.if__ "#{accumulator_var}.empty?" do
          builder.reset_index start_index_var
          builder.assign_result lexical_address, "ParseFailure.new(#{start_index_var}, #{nested_results_var})"
        end
        builder.else_ do
          builder.assign_result lexical_address, "SequenceSyntaxNode.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
        end
        builder.end_comment(parent_expression)
      end
    end
  end
end