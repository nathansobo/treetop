dir = File.dirname(__FILE__)
require 'rubygems'

$LOAD_PATH.unshift(File.join(dir, '..', 'vendor', 'rspec', 'lib'))
require 'spec'

unless $bootstrapped_compiler_being_tested
  load File.join(dir, 'bootstrap_compiler_being_tested.rb')
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
        
        parser_class_under_test.class_eval do
          def root
            _nt_expression_under_test
          end
        end
      end

      def testing_grammar(grammar_to_test)
        grammar_node = parse_with_metagrammar(grammar_to_test.strip, :grammar)
        test_parser_code = grammar_node.compile
        class_eval(test_parser_code)
        self.parser_class_under_test = const_get(grammar_node.parser_name.to_sym)
      end

      def generate_test_parser_for_expression(expression_node)
        builder = Compiler::RubyBuilder.new
        address = builder.next_address
        expression_node.compile(builder)
        %{
          class TestParser < Treetop::Runtime::CompiledParser
            include Treetop::Runtime
          
            attr_accessor :test_index
          
            def root
              _nt_test_expression
            end
          
            def reset_index
              @index = @test_index || 0
            end
          
            #{builder.ruby.tabrestto(10)}
          end
        }.tabto(0)
      end

      def parse_with_metagrammar(input, root)
        parser = Treetop::Compiler::MetagrammarParser.new
        parser.send(:prepare_to_parse, input)
        node = parser.send("_nt_#{root}".to_sym)
        
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
      result = test_parser.instance_eval do
        prepare_to_parse(input)
        @index = options[:at_index] if options[:at_index]
        root
      end
      
      yield result if block_given?
      result
    end
    
    Spec::Example::ExampleGroupFactory.register(:compiler, self)
  end
end
class String
  def tabrestto(n)
    self.gsub(/\n^/, "\n" + ' ' * n)
  end
end