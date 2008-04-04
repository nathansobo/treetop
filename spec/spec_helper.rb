dir = File.dirname(__FILE__)
require 'rubygems'
require 'benchmark'
require 'spec'

unless $bootstrapped_gen_1_metagrammar
  load File.join(dir, '..', 'lib', 'treetop', 'bootstrap_gen_1_metagrammar.rb')
end
include Treetop

Spec::Runner.configure do |config|
  config.mock_with :rr
end

module Treetop
  module Runtime
    class CompiledParser
      public :max_terminal_failure_first_index, :max_terminal_failure_last_index
    end
  end

  class TreetopExampleGroup < Spec::Example::ExampleGroup
    class << self
      
      attr_writer :parser_class_under_test
      
      def parser_class_under_test
        if @parser_class_under_test
          @parser_class_under_test
        else
          superclass.parser_class_under_test
        end
      end

      def testing_expression(expression_under_test)
        testing_grammar(%{
          grammar Test
            rule expression_under_test
	      }+expression_under_test+%{
	    end
          end
        }.tabto(0))
      end

      def testing_grammar(grammar_under_test)
        grammar_node = parse_with_metagrammar(grammar_under_test.strip, :grammar)
        parser_code = grammar_node.compile
        class_eval(parser_code)
        self.parser_class_under_test = const_get(grammar_node.parser_name.to_sym)
      end

      def parse_with_metagrammar(input, root)
        parser = Treetop::Compiler::MetagrammarParser.new
        parser.root = root
        node = parser.parse(input)
        raise parser.failure_reason unless node
        node
      end
    end

    attr_reader :parser

    def parse_with_metagrammar(input, root)
      self.class.parse_with_metagrammar(input, root)
    end

    def parser_class_under_test
      self.class.parser_class_under_test
    end

    def parse(input, options = {})
      @parser = parser_class_under_test.new
      parser.consume_all_input = options[:consume_all_input] if options.has_key?(:consume_all_input)
      parser.return_parse_failure = options[:return_parse_failure] if options.has_key?(:return_parse_failure)
      parser.return_propagations = options[:return_propagations] if options.has_key?(:return_propagations)

      result = parser.parse(input, options)
      yield result if block_given?
      result
    end

    def reparse
      parser.reparse
    end

    def result_cache
      parser.send(:expirable_result_cache)
    end

    def expire(range, length_change)
      parser.expire(range, length_change)
    end

    def compiling_grammar(grammar_under_test)
      lambda {
        grammar_node = parse_with_metagrammar(grammar_under_test.strip, :grammar)
        parser_code = grammar_node.compile
        [grammar_node, parser_code]
      }
    end

    def compiling_expression(expression_under_test)
      compiling_grammar(%{
        grammar Test
          rule expression_under_test
            #{expression_under_test}
          end
        end
      }.tabto(0))
    end

    def optionally_benchmark(&block)
      if BENCHMARK
        Benchmark.bm do |x|
          x.report(&block)
        end
      else
        yield
      end
    end

    Spec::Example::ExampleGroupFactory.register(:compiler, self)
    Spec::Example::ExampleGroupFactory.register(:runtime, self)
    Spec::Example::ExampleGroupFactory.register(:iterative_parsing, self)
  end
end

class Symbol
  def to_proc
    lambda do |x|
      x.send(self)
    end
  end
end

module PrintDependencies
  def print_dependencies(r, indent = 0)
    puts "  " * indent + r.inspect
    r.dependencies.each do |d|
      print_dependencies(d, indent + 1)
    end
  end
end
