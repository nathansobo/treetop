module Treetop
  class NodeCache
    def initialize
      @node_hash = Hash.new {|hash, key| hash[key] = Hash.new }
    end
  
    def empty?
      @node_hash.empty?
    end
  
    def store_node(nonterminal_sym, parse_result)
      @node_hash[parse_result.start_index][nonterminal_sym] = parse_result
    end
  
    def node_starting_at(nonterminal_sym, index)
      @node_hash[index][nonterminal_sym] if @node_hash[index]
    end
  end
end