module Treetop
  module Runtime
    class NodeCache

      def initialize
        @nodes = Hash.new {|h, k| h[k] = Hash.new }
        @stored_ranges = []
      end

      def store(rule_name, range, result)
        nodes[range.first][rule_name] = result
        stored_ranges.push(range)
      end

      def get(rule_name, start_index)
        nodes[start_index][rule_name]
      end

      def has_result?(rule_name, start_index)
        nodes.has_key?(start_index) && nodes[start_index].has_key?(rule_name)
      end

      def expire(range, length_change)
        stored_ranges.map! do |stored_range|
          if stored_range.intersects?(range)
            nodes.delete(stored_range.first)
            nil
          elsif stored_range.first >= range.last
            nodes[stored_range.first + length_change] = nodes.delete(stored_range.first)
            stored_range.transpose(length_change)
          else
            stored_range
          end
        end
        stored_ranges.compact!
      end

      protected
      attr_reader :nodes, :stored_ranges
    end
  end
end
