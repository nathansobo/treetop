module Treetop2
  module Compiler
    class TerminalExpression < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space)
        "r#{lexical_address} = parse_terminal(#{text_value})"
      end
    end
    
    class AnythingSymbol < ::Treetop::TerminalSyntaxNode
      def compile(lexical_address, address_space)
        "r#{lexical_address} = parse_anything"
      end
    end
    
    class CharacterClass < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space)
        "r#{lexical_address} = parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\'")}')"
      end
    end
    
    class Sequence < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address, address_space)
        storage_var = "s#{lexical_address}"
        start_index_var "i#{lexical_address}"
        
        ruby = "#{storage_var}, #{start_index_var} = [], index\n"
        
        compile_sequence_elements(sequence_elements, storage_var, address_space)
          
          
      end
              
      def compile_sequence_elements(sequence_elements, storage_var, address_space, level = 0)
        result_address = address_space.next_address
        result_var = "r#{result_address}"
      
        if sequence_elements.empty?
          
        
        else
          ruby = element.compile(result_address, address_space)
          ruby << indent(level) << "#{storage_var} << #{result_var}\n"
          ruby << indent(level) << "if #{storage_var}.last.success?\n"
          ruby << compile_sequence_elements(sequence_elements[1..-1], storage_var, address_space, level + 1)
        end
        
        
        
        return ruby
      end
    end
    
    
  end
end