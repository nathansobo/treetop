module Treetop
  module Nonterminal
    def self.create_nonterminal_class(name, containing_parser)
      nonterminal_class = Class.new
      nonterminal_class.extend(NonterminalClassMethods)
      nonterminal_class.instance_eval do
        include NonterminalInstanceMethods
      end
      nonterminal_class.name = name
      nonterminal_class.containing_parser = containing_parser
      return nonterminal_class
    end
  
    module NonterminalClassMethods
      attr_accessor :alternatives, :containing_parser, :name

      def nonterminal?
        true
      end
      
      def terminal?
        false
      end
    
      def add_alternative(alt)
        self.alternatives ||= Array.new
        alt.containing_nonterminal = self
        alternatives << alt
      end

      def parse_at(start, buffer, parser_instance)
        if cached_result = parser_instance.node_cache.node_starting_at(self.name, start)
          return cached_result
        end
      
        for alt in alternatives do
          parse_result = alt.parse_at(start, buffer, parser_instance)
          unless parse_result.failure?
            return construct_and_memoize_result(parse_result, alt, parser_instance)
          end
        end
        return ParseResult.new_failure(start)
      end
    
      def get_sibling(name)
        containing_parser.get_nonterminal(name)
      end
    
      def def_shared_methods(&methods_block)
        @has_shared_methods = true
        class_eval &methods_block
      end
        
      private
      def construct_and_memoize_result(result, alternative, parser_instance)
        value = self.new(result.value)
        value.extend(alternative.exclusive_methods_module)
        new_parse_result = ParseResult.new(value, result.start_index, result.end_index)
        parser_instance.node_cache.store_node(self.name, new_parse_result)
        return new_parse_result
      end
    end

    module NonterminalInstanceMethods
      attr_accessor :children

      def initialize(children=[])
        self.children = children
      end

      def [](index)
        children[index]
      end
    end  
  end
end
