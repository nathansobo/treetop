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
  module Test
  end

  module BehaviorEvalModuleMethods    
    def testing_expression(expression_to_test)
      prepend_before(:all) do        
        setup_test_parser(expression_to_test)
      end
      
      append_after(:all) do
        teardown_test_parser
      end
    end
  end
  
  module BehaviorEvalInstanceMethods
    def parse(input, options = {})
      test_parser = Test::TestParser.new
      test_parser.test_index = options[:at_index] || 0
      result = test_parser.parse(input)
      yield result if block_given?
      result
    end
    
    def setup_test_parser(expression_to_test)
      previous_root = metagrammar.set_root(:parsing_expression)
      expression_node = metagrammar_parser.parse(expression_to_test)
      metagrammar.set_root(previous_root)

      if expression_node.failure?
        raise "#{expression_to_test} cannot be parsed by the metagrammar."
      end
      
      builder = Compiler::RubyBuilder.new
      lexical_address = builder.next_address
      
      builder.in(2)
      expression_node.compile(lexical_address, builder)
      
      test_parser_code = %{
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
      #puts test_parser_code     
      Test.module_eval(test_parser_code)
    end
    
    def teardown_test_parser
      Test.module_eval do
        remove_const :TestParser
      end
    end
    
    def metagrammar
      Treetop2::Compiler::Metagrammar
    end
    
    def metagrammar_parser
      @metagrammar_parser ||= metagrammar.new_parser
    end
  end
  
  def before_eval
    @eval_module.extend BehaviorEvalModuleMethods
    include BehaviorEvalInstanceMethods
  end
  
  Spec::DSL::BehaviourFactory.add_behaviour_class(:compiler, self)
end