module Treetop
  module Runtime
    class NodeCache

      def initialize
        @nodes = Hash.new {|h, k| h[k] = Hash.new }
      end

      def store(rule_name, interval, result)
        nodes[rule_name][interval.first] = result
      end

      def get(rule_name, start_index)
        nodes[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        nodes[rule_name].has_key?(start_index)
      end

      protected
      attr_reader :nodes
    end
  end
end
