module Treetop
  module Runtime
    class ParseResult
      attr_reader :interval
      attr_accessor :parent, :source_rule_name, :node_index
      
      def initialize(interval)
        @interval = interval
      end

      def expire(expired_interval, length_change)
        if interval.intersects?(expired_interval)
          node_index[source_rule_name].delete(interval.first)
          return false
        end

        if interval.first >= expired_interval.last
          node_index[source_rule_name].delete(interval.first)
          @interval = interval.transpose(length_change)
          node_index[source_rule_name][interval.first] = self
        end
      end
    end
  end
end
