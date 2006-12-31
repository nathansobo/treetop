dir = File.dirname(__FILE__)
require "#{dir}/nonterminal"
require "#{dir}/node_cache"

class Symbol
  @gensym_counter = 0
  
  def self.gensym
    "Generated#{@gensym_counter += 1}".to_sym
  end
end

module Treetop
  module DefinesParsers
    def self.included(other_module)
      other_module.extend(ParserDefinitionMethods)
    end

    def create_parser_class(name)
      self.class.create_parser_class(name)
    end
  end

  module ParserDefinitionMethods
    def def_parser(name)
      const_set(name, create_parser_class)
    end
  
    def create_parser_class(name)
      parser_class = Class.new
      parser_class.extend(Parser::ClassMethods)
      parser_class.instance_eval { include Parser::InstanceMethods }
      parser_class.name = name
      return parser_class
    end
  end
  
  module Parser
    module ClassMethods
      attr_accessor :nonterminals, :root_sym, :name
  
      def add_nonterminal(name_sym)
        self.root_sym = name_sym unless nonterminals
        self.nonterminals ||= Hash.new
        nonterminal_class = Nonterminal::create_nonterminal_class(name_sym, self)
        nonterminals[name_sym] = nonterminal_class
        const_set(name_sym, nonterminal_class)
      end
  
      def kleene_closure(repeated_sym)
        kleene_nonterminal_sym = Symbol.gensym
        add_nonterminal(kleene_nonterminal_sym)
        add_repeating_alternative(kleene_nonterminal_sym, repeated_sym)
        add_empty_list_terminator_alternative(kleene_nonterminal_sym)
        return kleene_nonterminal_sym
      end

      def root
        nonterminals[root_sym]
      end

      def get_nonterminal(nonterminal_symbol)
        nonterminals[nonterminal_symbol]
      end
  
      private
      def create_nonterminal_class(name)
        nonterminal_class = Class.new
        nonterminal_class.extend(NonterminalClassMethods)
        nonterminal_class.instance_eval { include NonterminalInstanceMethods }
        nonterminal_class.name = name
        return nonterminal_class    
      end
  
      def add_repeating_alternative(nonterminal_sym, repeated_sym)
        alt = Alternative.new([repeated_sym, nonterminal_sym])
        alt.def_exclusive_methods do
          def children
            [@children[0]] + @children[1].children
          end
        end
        get_nonterminal(nonterminal_sym).add_alternative(alt)
      end
  
      def add_empty_list_terminator_alternative(nonterminal_sym)
        alt = Alternative.new("")
        alt.def_exclusive_methods do
          def children
            []
          end
        end
        get_nonterminal(nonterminal_sym).add_alternative(alt)
      end
    end         

    module InstanceMethods
      attr_accessor :node_cache

      def initialize
        self.node_cache = NodeCache.new
      end

      def parse(buffer)
        result = root.parse_at(0, buffer, self)
        return result.value if result.end_index == buffer.length
      end
  
      def get_nonterminal(nonterminal_symbol)
        parser_class.get_nonterminal(nonterminal_symbol)
      end
  
      def parser_class
        self.class
      end

      def root
        get_nonterminal(parser_class.root_sym)
      end  
    end
  end
end