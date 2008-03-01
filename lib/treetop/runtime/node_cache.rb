module Treetop
  module Runtime
    class NodeCache
      attr_reader :results
      
      def initialize
        @node_index = Hash.new {|h, k| h[k] = Hash.new }
        @terminal_results = []
        @results = []
      end

      def store(rule_name, result, additional_dependencies = [])
        memoization = Memoization.new(rule_name, result, node_index)
        memoization.dependencies = [result] + additional_dependencies
        memoization.dependencies.each do |dependency|
          register_dependency(dependency)
          dependency.memoizations.push(memoization)
        end
      end

      def get(rule_name, start_index)
        node_index[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        node_index[rule_name].has_key?(start_index)
      end

      def expire(range, length_change)
        terminal_results.clone.each do |result|
          result.expire if result.interval.intersects?(range)
        end
        results.each do |result|
          result.relocate(length_change) if result.interval.first >= range.last
        end
      end
      
      def delete_result(result)
        terminal_results.delete(result)
        results.delete(result)
      end

      protected
      
      def register_dependency(result)
        return if result.registered?
        result.node_cache = self
        if result.dependencies.empty?
          terminal_results.push(result)
        else
          result.dependencies.each do |subresult|
            subresult.dependents.push(result)
            register_dependency(subresult)
          end
        end
        results.push(result)
        result.registered = true
      end
      
      attr_reader :node_index, :terminal_results
    end
  end
end
