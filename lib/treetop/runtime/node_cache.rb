module Treetop
  module Runtime
    class NodeCache

      def initialize
        @node_index = Hash.new {|h, k| h[k] = Hash.new }
        @node_storages = []
      end

      def store(result)
        node_index[result.source_rule_name][result.interval.first] = result
        result.node_index = node_index
        node_storages.push(result)
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
  end
end
