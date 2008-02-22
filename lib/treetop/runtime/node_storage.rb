module Treetop
  module Runtime
    class NodeStorage
      attr_reader :rule_name, :result, :node_index

      def initialize(rule_name, result, node_index)
        @rule_name = rule_name
        @result = result
        @node_index = node_index
        result.storages.push(self)
      end

      def interval
        result.interval
      end

      def reflect_buffer_change(expired_interval, length_change)
        if interval.intersects?(expired_interval)
          expire(true)
          return false
        end

        if interval.first >= expired_interval.last
          node_index[rule_name].delete(interval.first)
          result.interval = interval.transpose(length_change)
          node_index[rule_name][interval.first] = result
        end

        true
      end

      def expire(propagate_to_result)
        node_index[rule_name].delete(interval.first) if node_index
        result.expire(false) if propagate_to_result
      end
    end
  end
end