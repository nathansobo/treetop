module Treetop
  module Runtime
    class NodeCache

      def initialize
        @nodes = Hash.new {|h, k| h[k] = Hash.new }
        @ranges = []
      end

      def store(rule_name, range, result)
        nodes[range.first][rule_name] = result
        ranges.push(range)
      end

      def get(rule_name, start_index)
        nodes[start_index][rule_name]
      end

      def has_result?(rule_name, start_index)
        nodes.has_key?(start_index) && nodes[start_index].has_key?(rule_name)
      end

      def expire(range, length_change)
        ranges.each do |range|
          
        end
      end

      protected
      attr_reader :nodes, :ranges
    end
  end
end
