module Treetop2
  module Compiler
    module Indent
      def indent(level)
        "  " * level
      end
    end
    
    class TerminalExpression < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space, level = 0)
        indent(level) + "r#{lexical_address} = parse_terminal(#{text_value})\n"
      end
    end
    
    class AnythingSymbol < ::Treetop::TerminalSyntaxNode
      def compile(lexical_address, address_space, level = 0)
        indent(level) + "r#{lexical_address} = parse_anything\n"
      end
    end
    
    class CharacterClass < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space, level = 0)
        indent(level) + "r#{lexical_address} = parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}')\n"
      end
    end
    
    class Sequence < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space, level = 0)
        result_var = "r#{lexical_address}"
        results_accumulator_var = "s#{lexical_address}"
        start_index_var = "i#{lexical_address}"
        
        ruby = indent(level) + "#{results_accumulator_var}, #{start_index_var} = [], index\n"        
        ruby << compile_sequence_elements(sequence_elements, results_accumulator_var, address_space, level)        
        ruby << indent(level) << "if #{results_accumulator_var}.last.success?\n"
        ruby << indent(level + 1) << "#{result_var} = SequenceSyntaxNode.new(input, #{start_index_var}...index, #{results_accumulator_var})\n"
        ruby << indent(level) << "else\n"
        ruby << indent(level + 1) << "#{result_var} = ParseFailure.new(#{start_index_var}, #{results_accumulator_var})\n"
        ruby << indent(level) << "end\n"
      end
              
      def compile_sequence_elements(elements, results_accumulator_var, address_space, level)
        result_address = address_space.next_address
        result_var = "r#{result_address}"
        
        ruby = elements.first.compile(result_address, address_space, level)
        ruby << indent(level) << "#{results_accumulator_var} << #{result_var}\n"
        
        if elements.size > 1
          ruby << indent(level) << "if #{result_var}.success?\n"
          ruby << compile_sequence_elements(elements[1..-1], results_accumulator_var, address_space, level + 1)
          ruby << indent(level) << "end\n"
        end
        
        return ruby
      end
    end
    
    class Choice < Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space, level = 0)
        result_var = "r#{lexical_address}"
        start_index_var = "i#{lexical_address}"
        nested_results_accumulator = "nr#{lexical_address}"
        
        ruby = indent(level) + "#{nested_results_accumulator}, #{start_index_var} = [], index\n"
        ruby << compile_alternatives(alternatives, result_var, start_index_var, nested_results_accumulator, address_space, level)
        return ruby
      end
      
      def compile_alternatives(alternatives, choice_result_var, choice_start_index, nested_results_accumulator, address_space, level)
        alternative_result_address = address_space.next_address
        alternative_result_var = "r#{alternative_result_address}"
        
        ruby = alternatives.first.compile(alternative_result_address, address_space, level)
        ruby << indent(level) << "#{nested_results_accumulator} << #{alternative_result_var}\n"
        
        ruby << indent(level) << "if (#{alternative_result_var}.success?)\n"
        ruby << indent(level + 1) << "#{choice_result_var} = #{alternative_result_var}\n"
        ruby << indent(level) << "else\n"
        
        if alternatives.size == 1
          ruby << indent(level + 1) << "self.index = #{choice_start_index}\n"
          ruby << indent(level + 1) << "#{choice_result_var} = ParseFailure.new(#{choice_start_index}, #{nested_results_accumulator})\n"
        else
          ruby << compile_alternatives(alternatives[1..-1], choice_result_var, choice_start_index, nested_results_accumulator, address_space, level + 1)
        end
        
        ruby << indent(level) << "end\n"
      end
    end
  end
end

class Treetop::SyntaxNode
  include Treetop2::Compiler::Indent
end
