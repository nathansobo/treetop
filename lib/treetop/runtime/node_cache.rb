module Treetop
  module Runtime
    class NodeCache

      def initialize
        @node_index = Hash.new {|h, k| h[k] = Hash.new }
        @registered_dependencies = []
      end

      def store(rule_name, result, additional_dependencies = [])
        memoization = Memoization.new(rule_name, result, node_index)
        ([result] + additional_dependencies).each do |dependency|
          register_dependency(dependency)
          dependency.dependents.push(memoization)
        end
      end

      def get(rule_name, start_index)
        node_index[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        node_index[rule_name].has_key?(start_index)
      end

      def expire(range, length_change)
        registered_dependencies.each do |dependency|
          dependency.expire if dependency.interval.intersects?(range)
        end
      end

      protected
      
      def register_dependency(dependency)
        return if dependency.registered?
        if dependency.dependencies.empty?
          registered_dependencies.push(dependency)
        else
          dependency.dependencies.each do |subdependency|
            subdependency.dependents.push(dependency)
            register_dependency(subdependency)
          end
        end
        dependency.registered = true
      end
      
      attr_reader :node_index, :registered_dependencies
    end
  end
end
