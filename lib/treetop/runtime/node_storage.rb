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
          expire(false)
          return false
        end

        if interval.first >= expired_interval.last
          node_index[rule_name].delete(interval.first)
          result.interval = interval.transpose(length_change)
          node_index[rule_name][interval.first] = result
        end

        true
      end
      
      def inspect
        "(:#{rule_name} - #{interval})"
      end

      def expire(propagate_to_parent)
        node_index[rule_name].delete(interval.first) if node_index
        #dependent_results.each { |dependent_result| dependent_result.expire(true) }
        #parent.expire(true) if parent && propagate_to_parent
      end
    end
  end
end