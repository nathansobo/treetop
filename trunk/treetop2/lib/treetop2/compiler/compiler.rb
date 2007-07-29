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
        indent(level) + "r#{lexical_address} = parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\'")}')\n"
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
  end
end

class Treetop::SyntaxNode
  include Treetop2::Compiler::Indent
end
