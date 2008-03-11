module Treetop
  module Runtime
    class Memoization
      attr_reader :rule_name, :result, :node_index
      attr_accessor :dependencies

      def initialize(rule_name, result, node_index)
        @rule_name = rule_name
        @result = result
        @node_index = node_index
        rule_index[interval.first] = result
      end

      def interval
        result.interval
      end

      def rule_index
        node_index[rule_name]
      end

      def relocate(length_change)
        if rule_index[interval.first] == result
          rule_index.delete(interval.first)
        end
        rule_index[interval.first + length_change] = result 
      end

      def expire
        dependencies.each do |dependency|
          dependency.memoizations.delete(self)
        end
        rule_index.delete(interval.first)
      end
      
      def inspect
        "#{rule_name}: #{result.inspect}"
      end
    end
  end
end