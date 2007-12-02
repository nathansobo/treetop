dir = File.dirname(__FILE__)
require 'rubygems'
require File.expand_path(File.join(dir, 'screw', 'unit'))

unless $bootstrapped_compiler_under_test
  # Loading trusted version of Treetop to compile the compiler
  trusted_treetop_path = Gem.source_index.find_name('treetop', ["1.1.2"]).last.full_gem_path
  require File.join(trusted_treetop_path, 'lib', 'treetop')

  # Relocating trusted version of Treetop to Trusted::Treetop
  Trusted = Module.new
  Trusted::Treetop = Treetop
  Object.send(:remove_const, :Treetop)
  Object.send(:remove_const, :TREETOP_ROOT)

  # Requiring version of Treetop that is under test
  require File.expand_path(File.join(dir, '..', 'lib', 'treetop'))
  # Remove stale Metagrammar defined by the generated metagrammar.rb in system under test
  Treetop::Compiler.send(:remove_const, :Metagrammar)

  # Compile and evaluate freshly generated metagrammar source
  METAGRAMMAR_PATH = File.join(TREETOP_ROOT, 'compiler', 'metagrammar.treetop')
  compiled_metagrammar_source = Trusted::Treetop::Compiler::GrammarCompiler.new.ruby_source(METAGRAMMAR_PATH)
  Object.class_eval(compiled_metagrammar_source)

  include Treetop
  $bootstrapped_compiler_under_test = true
end

class CompilerTestCase < Screw::Unit::TestCase
  class << self
    attr_accessor :parser_class_under_test
    
    def testing_expression(expression_to_test)
      rule_node = parse_with_metagrammar_2("rule test_expression\n" + expression_to_test + "\nend", :parsing_rule)
      test_parser_code = generate_test_parser_for_expression(rule_node)
      #puts test_parser_code
      class_eval(test_parser_code)
      self.parser_class_under_test = const_get(:TestParser)
    end

    def testing_grammar(grammar_to_test)
      grammar_node = parse_with_metagrammar_2(grammar_to_test.strip, :grammar)
      test_parser_code = grammar_node.compile
      # puts test_parser_code
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

    def parse_with_metagrammar_2(input, root)
      parser = Treetop::Compiler::MetagrammarParser.new
      parser.send(:prepare_to_parse, input)
      node = parser.send("_nt_#{root}".to_sym)
      raise "#{input} cannot be parsed by the metagrammar: #{node.nested_failures.map {|f| f.to_s}.join("\n")}" if node.failure? 
      node
    end

  end
  
  def parse_with_metagrammar_2(input, root)
    self.class.parse_with_metagrammar_2(input, root)
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