module Treetop
  module Runtime
    class CompiledParser
      include Treetop::Runtime
      
      attr_reader :input, :index, :terminal_failures, :max_terminal_failure_first_index, :max_terminal_failure_last_index
      attr_writer :root
      attr_accessor :consume_all_input, :return_parse_failure, :return_propagations
      alias :consume_all_input? :consume_all_input
      alias :return_parse_failure? :return_parse_failure
      alias :return_propagations? :return_propagations
      
      def initialize
        self.consume_all_input = true
      end

      def parse(input, options = {})
        prepare_to_parse(input)
        parse_root(options)
      end

      def reparse
        reset_parse_state
        parse_root
      end

      def expire(range, length_change)
        expirable_result_cache.expire(range, length_change)
      end

      def failure_index
        max_terminal_failure_first_index
      end

      def failure_line
        terminal_failures && input.line_of(failure_index)
      end

      def failure_column
        terminal_failures && input.column_of(failure_index)
      end

      def failure_reason
        return nil unless (tf = terminal_failures) && tf.size > 0
        "Expected " +
          (tf.size == 1 ?
           tf[0].expected_string :
                 "one of #{tf.map{|f| f.expected_string}.uniq*', '}"
          ) +
                " at line #{failure_line}, column #{failure_column} (byte #{failure_index+1})" +
                " after #{input[index...failure_index]}"
      end

      protected
      
      attr_reader :node_cache, :expirable_result_cache, :input_length
      attr_writer :index

      def parse_root(options = {})
        @index = options[:index] if options[:index]
        result = send("_nt_#{root}")
        if result.is_a?(ParseFailure)
          if return_parse_failure?
            return result
          else
            return nil
          end
        end
        return nil if (consume_all_input? && index != input.size)

        if return_propagations?
          result
        else
          result.element
        end
      end

      def prepare_to_parse(input)
        @input = input
        @node_cache = Hash.new {|hash, key| hash[key] = Hash.new}
        @expirable_result_cache = ResultCache.new
        reset_parse_state
      end

      def reset_parse_state
        reset_index
        @input_length = input.length
        @terminal_failures = []
        @max_terminal_failure_first_index = 0
        @max_terminal_failure_last_index = 0
      end
      
      def reset_index
        @index = 0
      end
      
      def parse_anything(node_class = SyntaxNode, inline_module = nil)
        if index < input.length
          result = node_class.new(input, index...(index + 1))
          result.extend(inline_module) if inline_module
          @index += 1
          result
        else
          terminal_parse_failure("any character", 1)
        end
      end
    
      def terminal_parse_failure(expected_string, length=0)
        index_plus_length = index + length
        @max_terminal_failure_last_index = index_plus_length if index_plus_length > max_terminal_failure_last_index
        last_index = [index_plus_length, input_length].min
        range = (index_plus_length > input_length) ? (index..last_index) : (index...last_index)

        failure = TerminalParseFailure.new(range, expected_string)

        if index > max_terminal_failure_first_index
          @max_terminal_failure_first_index = index
          @terminal_failures = [failure]
        elsif index == max_terminal_failure_first_index
          terminal_failures.push(failure)
        end

        failure
      end
    end
  end
end
