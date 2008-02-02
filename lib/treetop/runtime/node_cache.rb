module Treetop
  module Runtime
    class NodeCache

      def initialize
        @nodes = Hash.new {|h, k| h[k] = Hash.new }
        @node_storages = []
      end

      def store(rule_name, range, result)
        nodes[range.first][rule_name] = result
        node_storages.push(NodeStorage.new(nodes, rule_name, range))
      end

      def get(rule_name, start_index)
        nodes[start_index][rule_name]
      end

      def has_result?(rule_name, start_index)
        nodes.has_key?(start_index) && nodes[start_index].has_key?(rule_name)
      end

      def expire(range, length_change)
        self.node_storages = node_storages.select do |node_storage|
          node_storage.expire(range, length_change)
        end
      end

      protected
      attr_reader :nodes
      attr_accessor :node_storages
    end

    class NodeStorage
      attr_reader :nodes, :rule_name
      attr_accessor :range

      def initialize(nodes, rule_name, range)
        @nodes = nodes
        @rule_name = rule_name
        @range = range
      end

      def expire(expired_range, length_change)
        if range.intersects?(expired_range)
          nodes[range.first].delete(rule_name)
          return false
        end

        if range.first >= expired_range.last
          node_to_move = nodes[range.first].delete(rule_name)
          self.range = range.transpose(length_change)
          node_to_move.interval = range if node_to_move
          nodes[range.first][rule_name] = node_to_move
        end
      end
    end
  end
end
