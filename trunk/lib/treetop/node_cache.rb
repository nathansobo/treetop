module Treetop
  class NodeCache
    def initialize
      @node_hash = Hash.new {|hash, key| hash[key] = Hash.new }
    end
  
    def empty?
      @node_hash.empty?
    end
  
    def store_node(nonterminal_symbol, syntax_node)      
      hash_for_nonterm = (@node_hash[nonterminal_symbol] ||= Hash.new)
      hash_for_nonterm[syntax_node.interval.begin] = syntax_node
    end
  
    def node_starting_at(nonterminal_symbol, index)
      @node_hash[nonterminal_symbol][index] if @node_hash[nonterminal_symbol]
    end
  end
end