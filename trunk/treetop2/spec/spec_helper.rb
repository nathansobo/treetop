dir = File.dirname(__FILE__)
$:.unshift(File.join(dir, *%w[.. lib]))
require 'rubygems'
require 'spec'
require 'treetop2'

require File.expand_path('treetop', File.join(dir, *%w[.. .. lib]))
unless Treetop2.const_defined?(:Metagrammar)
  load_grammar File.join(TREETOP_2_ROOT, *%w[compiler metagrammar])
end

include Treetop2

class CompilerBehaviour < Spec::DSL::Behaviour
  module Test
  end

  module BehaviorEvalModuleMethods    
    def testing_expression(expression_to_test)
      previous_root = metagrammar.set_root(:terminal)      
      setup_test_parser(expression_to_test)
      metagrammar.set_root(previous_root)
    end
    
    def setup_test_parser(expression_to_test)
      expression_node = metagrammar_parser.parse(expression_to_test)

      if expression_node.failure?
        raise "#{expression_to_test} cannot be parsed by the metagrammar."
      end
      
      Test.module_eval %{
        class TestParser < CompiledParser
          def parse(input)
            prepare_to_parse(input)
            return _nt_test_expression
          end
          
          def _nt_test_expression
            #{expression_node.proc_body}
          end
        end
      }
      
      after(:all) { Test.send(:remove_const, :TestParser) }
    end
    
    def metagrammar
      Treetop2::Compiler::Metagrammar
    end
    
    def metagrammar_parser
      @metagrammar_parser ||= metagrammar.new_parser
    end
  end
  
  module BehaviorEvalInstanceMethods
    def parse(input, options = {})
      test_parser = Test::TestParser.new
      test_parser.instance_eval { @index = options[:at_index] || 0 }
      result = test_parser.parse(input)
      yield result if block_given?
      result
    end
  end
  
  def before_eval
    @eval_module.extend BehaviorEvalModuleMethods
    include BehaviorEvalInstanceMethods
  end
  
  Spec::DSL::BehaviourFactory.add_behaviour_class(:compiler, self)
end