module Treetop
  module Runtime
    class Memoization
      attr_reader :rule_name, :result, :node_index

      def initialize(rule_name, result, node_index)
        @rule_name = rule_name
        @result = result
        @node_index = node_index
        node_index[rule_name][result.interval.first] = result
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

      def expire
        node_index[rule_name].delete(interval.first) if node_index
      end
    end
  end
end