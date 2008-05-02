module Treetop
  module Runtime
    class Memoization
      attr_reader :rule_name, :result, :result_index
      attr_accessor :dependencies

      def initialize(rule_name, result, result_index)
        @rule_name = rule_name
        @result = result
        @result_index = result_index
        rule_index[interval.first] = result
      end

      def interval
        result.interval
      end

      def rule_index
        result_index[rule_name]
      end

      def relocate(length_change)
        if rule_index[interval.first] == result
          rule_index.delete(interval.first)
        end
        rule_index[interval.first + length_change] = result 
      end

      def release
        result.memoizations.delete(self)
        rule_index.delete(interval.first)
        result.release
      end
      
      def inspect
        "#{rule_name}: #{result.inspect}"
      end
    end
  end
end