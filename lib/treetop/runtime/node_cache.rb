module Treetop
  module Runtime
    class NodeCache

      def initialize
        @node_index = Hash.new {|h, k| h[k] = Hash.new }
        @node_storages = []
      end

      def store(result)
        node_index[result.source_rule_name][result.interval.first] = result
        node_storages.push(NodeStorage.new(node_index, result.source_rule_name, result.interval))
      end

      def get(rule_name, start_index)
        node_index[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        node_index[rule_name].has_key?(start_index)
      end

      def expire(range, length_change)
        self.node_storages = node_storages.select do |node_storage|
          node_storage.expire(range, length_change)
        end
      end

      protected
      attr_reader :node_index
      attr_accessor :node_storages
    end

    class NodeStorage
      attr_reader :node_index, :rule_name
      attr_accessor :range

      def initialize(node_index, rule_name, range)
        @node_index = node_index
        @rule_name = rule_name
        @range = range
      end

      def expire(expired_range, length_change)
        if range.intersects?(expired_range)
          node_index[rule_name].delete(range.first)
          return false
        end

        if range.first >= expired_range.last
          node_to_move = node_index[rule_name].delete(range.first)
          self.range = range.transpose(length_change)
          node_to_move.interval = range if node_to_move
          node_index[rule_name][range.first] = node_to_move
        end
      end
    end
  end
end
