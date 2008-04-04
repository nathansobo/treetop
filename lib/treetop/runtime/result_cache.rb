module Treetop
  module Runtime
    class ResultCache
      attr_reader :results
      
      def initialize
        @result_index = Hash.new {|h, k| h[k] = Hash.new }
        @results = []
      end

      def store_result(rule_name, result)
        result.memoizations.push(Memoization.new(rule_name, result, result_index))
        register_result(result)
      end

      def get_result(rule_name, start_index)
        result_index[rule_name][start_index]
      end

      def has_result?(rule_name, start_index)
        result_index[rule_name].has_key?(start_index)
      end

      def expire(range, length_change)
        @results_to_delete = []
        @memoizations_to_expire = []

        results.each do |result|
          result.expire if result.interval.intersects?(range)
        end

        @results -= results_to_delete
        memoizations_to_expire.uniq.each do |memoization|
          memoization.expire
        end

        results.each do |result|
          result.relocate(length_change) if result.interval.first >= range.last
        end
      end

      def schedule_memoization_expiration(memoization)
        memoizations_to_expire.push(memoization)
      end

      def schedule_result_deletion(result)
        results_to_delete.push(result)
      end

      def inspect
        s = ""
        result_index.each do |rule_name, subhash|
          s += "#{rule_name}: "
          subhash.each do |i, v|
            s += "#{i} => #{v.inspect}, "
          end
          s += "\n"
        end
        s
      end

      protected
      
      def register_result(result)
        return if result.registered?
        result.result_cache = self

        if result.child_results
          result.child_results.each do |child_result|
            child_result.parent = result
            register_result(child_result)
          end
        end

        result.dependencies.each do |subresult|
          subresult.dependents.push(result)
          register_result(subresult)
        end

        result.registered = true
        results.push(result)
      end
      
      attr_reader :result_index, :results_to_delete, :memoizations_to_expire
    end
  end
end
