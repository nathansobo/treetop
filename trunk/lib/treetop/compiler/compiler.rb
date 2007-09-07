module Treetop
  module Compiler
    module AtomicExpression
      def inline_modules
        []
      end
    end
    
    class TreetopFile < Runtime::SyntaxNode

      def compile
        (elements.map {|elt| elt.compile}).join
      end
    end
    
    class Grammar < Runtime::SyntaxNode

      def compile
        builder = RubyBuilder.new                        
        builder.class_declaration "#{grammar_name.text_value} < ::Treetop::Runtime::CompiledParser" do
          builder.in(input.column_of(interval.begin))
          builder << "include ::Treetop::Runtime"
          builder.newline
          parsing_rule_sequence.compile(builder)
        end
      end
    end
    
    class ParsingRuleSequence < Runtime::SyntaxNode

      def compile(builder)
        builder.method_declaration("root") do
          builder << rules.first.method_name
        end
        builder.newline
        
        rules.each do |rule|
          rule.compile(builder)
          builder.newline
        end
      end
    end

    class ParsingRule < Runtime::SyntaxNode

      def compile(builder)
        compile_inline_module_declarations(builder)
        builder.reset_addresses
        expression_address = builder.next_address
        result_var = "r#{expression_address}"
        
        builder.method_declaration(method_name) do
          builder.assign 'start_index', 'index'
          builder.assign 'cached', "node_cache[:#{name}][index]"
          builder.if_ 'cached' do
            builder << '@index = cached.interval.end'
            builder << 'return cached'
          end
          builder.newline
          
          parsing_expression.compile(expression_address, builder)
          
          builder.newline
          builder.assign "node_cache[:#{name}][start_index]", result_var
          builder.newline
          
          builder << "return #{result_var}"
        end
      end
      
      def compile_inline_module_declarations(builder)
        parsing_expression.inline_modules.each_with_index do |inline_module, i|
          inline_module.compile(i, self, builder)
          builder.newline
        end
      end
      
      def method_name
        "_nt_#{name}"
      end
      
      def name
        nonterminal.text_value
      end
    end
    
    class ParenthesizedExpression < Runtime::SyntaxNode

      def compile(address, builder, parent_expression = nil)
        elements[2].compile(address, builder)
      end
    end
    
    class Nonterminal < Runtime::SyntaxNode

      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        use_vars :result
        assign_result "_nt_#{text_value}"
      end
    end
    
    class Terminal < Runtime::SyntaxNode

      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_terminal(#{text_value}, #{node_class}#{optional_arg(inline_module_name)})"
      end
    end
    
    class AnythingSymbol < Runtime::SyntaxNode

      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_anything(#{node_class}#{optional_arg(inline_module_name)})"
      end
    end
    
    class CharacterClass < Runtime::SyntaxNode

      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}', #{node_class}#{optional_arg(inline_module_name)})"
      end
    end
    
    class Sequence < Runtime::SyntaxNode

      include ParsingExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        begin_comment(self)
        use_vars :result, :start_index, :accumulator, :nested_results
        compile_sequence_elements(sequence_elements)
        builder.if__ "#{accumulator_var}.last.success?" do
          assign_result "(#{node_class_declarations.node_class}).new(input, #{start_index_var}...index, #{accumulator_var})"
          builder << "#{result_var}.extend(#{sequence_element_accessor_module_name})" if sequence_element_accessor_module_name
          builder << "#{result_var}.extend(#{inline_module_name})" if inline_module_name
        end
        builder.else_ do
          reset_index
          assign_failure start_index_var, accumulator_var
        end
        end_comment(self)
      end
      
      def compile_sequence_elements(elements)
        obtain_new_subexpression_address
        elements.first.compile(subexpression_address, builder)
        accumulate_subexpression_result
        if elements.size > 1
          builder.if_ subexpression_success? do
            compile_sequence_elements(elements[1..-1])
          end
        end
      end
      
      def sequence_element_accessor_module
        @sequence_element_accessor_module ||= SequenceElementAccessorModule.new(sequence_elements)
      end
      
      def sequence_element_accessor_module_name
        sequence_element_accessor_module.module_name
      end
    end
    
    class Choice < Runtime::SyntaxNode

      include ParsingExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        begin_comment(self)
        use_vars :result, :start_index, :nested_results
        compile_alternatives(alternatives)
        end_comment(self)
      end
      
      def compile_alternatives(alternatives)
        obtain_new_subexpression_address
        alternatives.first.compile(subexpression_address, builder)
        accumulate_nested_result
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
          builder << "#{subexpression_result_var}.update_nested_results(#{nested_results_var})"
        end
        builder.else_ do
          if alternatives.size == 1
            reset_index
            assign_failure start_index_var, nested_results_var
          else
            compile_alternatives(alternatives[1..-1])
          end
        end
      end
    end
    
    
    class Repetition < Runtime::SyntaxNode

      include ParsingExpression
      
      def compile(address, builder, parent_expression)
        super
        repeated_expression = parent_expression.atomic
        begin_comment(parent_expression)
        use_vars :result, :accumulator, :nested_results, :start_index

        builder.loop do
          obtain_new_subexpression_address
          repeated_expression.compile(subexpression_address, builder)
          accumulate_nested_result
          builder.if__ subexpression_success? do
            accumulate_subexpression_result
          end
          builder.else_ do
            builder.break
          end
        end
      end
      
      def inline_module_name
        parent_expression.inline_module_name
      end
      
      def assign_and_extend_result
        assign_result "#{node_class}.new(input, #{start_index_var}...index, #{accumulator_var}, #{nested_results_var})"
        builder << "#{result_var}.extend(#{inline_module_name})" if inline_module_name
      end
    end
    
    class ZeroOrMore < Repetition
      def compile(address, builder, parent_expression)
        super
        assign_and_extend_result
        end_comment(parent_expression)
      end
    end
    
    class OneOrMore < Repetition
      def compile(address, builder, parent_expression)
        super
        builder.if__ "#{accumulator_var}.empty?" do
          reset_index
          assign_failure start_index_var, nested_results_var
        end
        builder.else_ do
          assign_and_extend_result
        end
        end_comment(parent_expression)
      end
    end
    
    class Optional < Runtime::SyntaxNode

      include ParsingExpression
      
      def compile(address, builder, parent_expression)
        super
        use_vars :result
        obtain_new_subexpression_address
        parent_expression.atomic.compile(subexpression_address, builder)
        
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
        end
        builder.else_ do
          assign_result epsilon_node
        end
      end
    end
    
    class Predicate < Runtime::SyntaxNode

      include ParsingExpression

      def compile(address, builder, parent_expression)
        super
        begin_comment(parent_expression)
        use_vars :result, :start_index
        obtain_new_subexpression_address
        parent_expression.predicated_expression.compile(subexpression_address, builder)
        builder.if__(subexpression_success?) { when_success }
        builder.else_ { when_failure }
        end_comment(parent_expression)
      end
      
      def assign_failure
        super(start_index_var, "#{subexpression_result_var}.nested_failures")
      end
      
      def assign_success
        reset_index
        assign_result epsilon_node
      end
    end
    
    class AndPredicate < Predicate
      def when_success
        assign_success
      end

      def when_failure
        assign_failure
      end
    end
    
    class NotPredicate < Predicate
      def when_success
        assign_failure
      end
      
      def when_failure
        assign_success
      end
    end
    
    module InlineModuleMixin
      attr_reader :module_name
      
      def compile(index, rule, builder)
        @module_name = "#{rule.name.camelize}#{index}"
      end
    end
    
    class InlineModule < Runtime::SyntaxNode

      include InlineModuleMixin
      
      def compile(index, rule, builder)
        super
        builder.module_declaration(module_name) do
          builder << ruby_code.gsub(/\A\n/, '').rstrip
        end
      end
      
      def ruby_code
        elements[1].text_value
      end
    end
    
    class SequenceElementAccessorModule
      include InlineModuleMixin   
      attr_reader :sequence_elements
      
      def initialize(sequence_elements)
        @sequence_elements = sequence_elements
      end
      
      def compile(index, rule, builder)
        super
        builder.module_declaration(module_name) do
          sequence_elements.each_with_index do |element, index|
            if element.label_name
              builder.method_declaration(element.label_name) do
                builder << "elements[#{index}]"
              end
              builder.newline unless index == sequence_elements.size - 1
            end
          end
        end
      end
    end
  end
end