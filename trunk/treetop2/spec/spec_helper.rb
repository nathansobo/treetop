dir = File.dirname(__FILE__)
require 'rubygems'
require 'spec'

$:.unshift(File.join(dir, *%w[.. lib]))

require 'treetop2'

unless Treetop2::Compiler.const_defined?(:Metagrammar)
  load_grammar File.join(TREETOP_2_ROOT, *%w[compiler metagrammar])
end

include Treetop2

class CompilerBehaviour < Spec::DSL::Behaviour

  module BehaviorEvalModuleMethods
    def testing_expression(expression_to_test)
      prepend_before(:all) do        
        setup_test_expression(expression_to_test)
      end
    end
    
    def testing_grammar(grammar_to_test)
      prepend_before(:all) do        
        setup_test_grammar(grammar_to_test)
      end
    end
  end
  
  module BehaviorEvalInstanceMethods
    
    attr_reader :parser_class_under_test
    
    def parse(input, options = {})
      test_parser = parser_class_under_test.new
      test_parser.test_index = options[:at_index] if options[:at_index]
      result = test_parser.parse(input)
      yield result if block_given?
      result
    end
    
    def test_module
      @test_module ||= Module.new
    end
    
    def teardown_test_module
      @test_module = nil
    end
    
    def setup_test_grammar(grammar_to_test)
      grammar_node = parse_with_metagrammar(grammar_to_test, :grammar)
      test_parser_code = grammar_node.compile
      #puts test_parser_code
      test_module.module_eval(test_parser_code)
      @parser_class_under_test = test_module.const_get(grammar_node.grammar_name.text_value.to_sym)
    end
    
    def setup_test_expression(expression_to_test)
      expression_node = parse_with_metagrammar(expression_to_test, :parsing_expression)
      test_parser_code = generate_test_parser_for_expression(expression_node)
      #puts test_parser_code
      test_module.module_eval(test_parser_code)
      @parser_class_under_test = test_module.const_get(:TestParser)
    end
    
    def generate_test_parser_for_expression(expression_node)
      builder = Compiler::RubyBuilder.new
      lexical_address = builder.next_address
      builder.in(2)
      expression_node.compile(lexical_address, builder)
      %{
class TestParser < CompiledParser
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
#{builder.ruby}
    return r#{lexical_address}
  end
end
}
    end
    
    def parse_with_metagrammar(input, root = nil)
      previous_root = metagrammar.set_root(root) if root
      node = metagrammar_parser.parse(input)
      metagrammar.set_root(previous_root) if root
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
  
  def before_eval
    append_after { teardown_test_module }
    @eval_module.extend BehaviorEvalModuleMethods
    include BehaviorEvalInstanceMethods
  end
  
  Spec::DSL::BehaviourFactory.add_behaviour_class(:compiler, self)
end