dir = File.dirname(__FILE__)
$:.unshift(File.join(dir, *%w[.. lib]))
require File.expand_path(File.join(dir, 'f', 'unit'))
require 'treetop2'
require 'rubygems'
require 'facet/string/tab'

unless Object.const_defined?(:METAGRAMMAR_PATH)
  METAGRAMMAR_PATH = File.join(TREETOP_2_ROOT, 'compiler', 'metagrammar.treetop')
  load_grammar METAGRAMMAR_PATH
end

include Treetop2

class CompilerTestCase < F::Unit::TestCase
  class << self
    attr_accessor :parser_class_under_test
    
    def testing_expression(expression_to_test)
      expression_node = parse_with_metagrammar(expression_to_test, :parsing_expression)
      test_parser_code = generate_test_parser_for_expression(expression_node)
      #puts test_parser_code
      class_eval(test_parser_code)
      self.parser_class_under_test = const_get(:TestParser)
    end
    
    def testing_grammar(grammar_to_test)
      grammar_node = parse_with_metagrammar(grammar_to_test, :grammar)
      test_parser_code = grammar_node.compile
      #puts test_parser_code
      class_eval(test_parser_code)
      self.parser_class_under_test = const_get(grammar_node.grammar_name.text_value.to_sym)
    end
    

    def generate_test_parser_for_expression(expression_node)
      builder = Compiler::RubyBuilder.new
      address = builder.next_address
      expression_node.compile(address, builder)
      %{
        class TestParser < Treetop2::Parser::CompiledParser
          include Treetop2::Parser
          attr_accessor :test_index

          def parse(input)
            prepare_to_parse(input)
            return _nt_test_expression
          end

          def prepare_to_parse(input)
            self.class.clear_subexpression_procs
            @input = input
            @index = test_index || 0
          end

          def _nt_test_expression
            #{builder.ruby.tabrestto(12)}
            return r#{address}
          end
        end
      }.tabto(0)
    end

    def parse_with_metagrammar(input, root)
      previous_root = metagrammar.set_root(root)
      node = metagrammar_parser.parse(input)
      metagrammar.set_root(previous_root)
      raise "#{input} cannot be parsed by the metagrammar." if node.failure? 
      node
    end

    def metagrammar
      Treetop2::Compiler::Metagrammar
    end

    def metagrammar_parser
      @metagrammar_parser ||= metagrammar.new_parser
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
    test_parser.test_index = options[:at_index] if options[:at_index]
    result = test_parser.parse(input)
    yield result if block_given?
    result
  end
end

class String
  def tabrestto(n)
    self.gsub(/\n^/, "\n" + ' ' * n)
  end
end