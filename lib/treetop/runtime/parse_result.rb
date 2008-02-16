module Treetop
  module Runtime
    class ParseResult
      attr_reader :interval, :dependent_results
      attr_accessor :parent, :source_rule_name, :node_index, :propagate_expiration_to_parent
      alias :propagate_expiration_to_parent? :propagate_expiration_to_parent
      
      def initialize(interval)
        @interval = interval
        @dependent_results = []
      end

      def reflect_buffer_change(expired_interval, length_change)
        if interval.intersects?(expired_interval)
          expire(false)
          return false
        end

        if interval.first >= expired_interval.last
          node_index[source_rule_name].delete(interval.first)
          @interval = interval.transpose(length_change)
          node_index[source_rule_name][interval.first] = self
        end
        true
      end

      def expire(propagate_to_parent)
        node_index[source_rule_name].delete(interval.first) if node_index
        dependent_results.each { |dependent_result| dependent_result.expire(true) }
        parent.expire(true) if parent && propagate_to_parent
      end
    end
  end
end
