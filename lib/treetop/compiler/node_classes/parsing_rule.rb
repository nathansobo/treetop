module Treetop
  module Compiler
    class ParsingRule < Runtime::SyntaxNode

      def compile(builder)
        compile_inline_module_declarations(builder)
        generate_method_definition(builder)
      end
      
      def compile_inline_module_declarations(builder)
        parsing_expression.inline_modules.each_with_index do |inline_module, i|
          inline_module.compile(i, self, builder)
          builder.newline
        end
      end
      
      def generate_method_definition(builder)
        builder.reset_addresses
        expression_address = builder.next_address
        result_var = "r#{expression_address}"
        
        builder.method_declaration(method_name) do
          builder.assign 'start_index', 'index'
          generate_cache_lookup(builder)
          builder.newline
          parsing_expression.compile(expression_address, builder)
          builder.newline
          generate_cache_storage(builder, result_var)
          builder.newline          
          builder << "return #{result_var}"
        end
      end
      
      def generate_cache_lookup(builder)
        builder.if_ "expirable_node_cache.has_result?(:#{name}, index)" do
          builder.assign 'cached', "expirable_node_cache.get(:#{name}, index)"
          builder << '@index = cached.interval.end if cached'
          builder << 'return cached'
        end
      end
      
      def generate_cache_storage(builder, result_var)
        builder << "expirable_node_cache.store(:#{name}, start_index..index, #{result_var})"
      end
      
      def method_name
        "_nt_#{name}"
      end
      
      def name
        nonterminal.text_value
      end
    end
  end
end