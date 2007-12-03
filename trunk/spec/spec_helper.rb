dir = File.dirname(__FILE__)
require 'rubygems'

$LOAD_PATH.unshift(File.join(dir, '..', 'vendor', 'rspec', 'lib'))
require 'spec'

unless $bootstrapped_gen_1_metagrammar
  load File.join(dir, '..', 'lib', 'treetop', 'bootstrap_gen_1_metagrammar.rb')
end
include Treetop

module Treetop
  class CompilerExampleGroup < Spec::Example::ExampleGroup
    class << self
      attr_accessor :parser_class_under_test
    
      def testing_expression(expression_under_test)
        testing_grammar(%{
          grammar Test
            rule expression_under_test
              #{expression_under_test}
            end
          end
        }.tabto(0))
      end

      def testing_grammar(grammar_to_test)
        grammar_node = parse_with_metagrammar(grammar_to_test.strip, :grammar)
        test_parser_code = grammar_node.compile
        class_eval(test_parser_code)
        self.parser_class_under_test = const_get(grammar_node.parser_name.to_sym)
      end

      def parse_with_metagrammar(input, root)
        parser = Treetop::Compiler::MetagrammarParser.new
        parser.root = root
        node = parser.parse(input)
        raise "#{input} cannot be parsed by the metagrammar: #{node.nested_failures.map {|f| f.to_s}.join("\n")}" if node.failure? 
        node
      end
    end
  
    def parse_with_metagrammar(input, root)
      self.class.parse_with_metagrammar(input, root)
    end
  
    def parser_class_under_test
      self.class.parser_class_under_test
    end
  
    def parse(input, options = {})
      test_parser = parser_class_under_test.new
      unless options[:consume_all_input].nil?
        test_parser.consume_all_input = options.delete(:consume_all_input)
      end
      result = test_parser.parse(input, options)
      yield result if block_given?
      result
    end
    
    Spec::Example::ExampleGroupFactory.register(:compiler, self)
  end
end