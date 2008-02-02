module Treetop
  module Runtime
    class NodeCache

      def initialize
        @nodes = Hash.new {|h, k| h[k] = Hash.new }
        @stored_nodes = []
      end

      def store(rule_name, range, result)
        nodes[range.first][rule_name] = result
        stored_nodes.push(NodeStorage.new(rule_name, range))
      end

      def get(rule_name, start_index)
        nodes[start_index][rule_name]
      end

      def has_result?(rule_name, start_index)
        nodes.has_key?(start_index) && nodes[start_index].has_key?(rule_name)
      end

      def expire(range, length_change)
        stored_nodes.map! do |node_storage|
          if node_storage.range.intersects?(range)
            nodes[node_storage.range.first].delete(node_storage.rule_name)
            nil
          elsif node_storage.range.first >= range.last
            node_to_move = nodes[node_storage.range.first].delete(node_storage.rule_name)
            node_to_move.interval = node_to_move.interval.transpose(length_change) if node_to_move
            nodes[node_storage.range.first + length_change][node_storage.rule_name] = node_to_move
            node_storage.range = node_storage.range.transpose(length_change) 
          else
            node_storage
          end
        end
        stored_nodes.compact!
      end

      protected
      attr_reader :nodes, :stored_nodes
    end

    class NodeStorage
      attr_reader :rule_name
      attr_accessor :range

      def initialize(rule_name, range)
        @rule_name = rule_name
        @range = range
      end
    end
  end
end
