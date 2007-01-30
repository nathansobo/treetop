require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A grammar for treetop grammars" do
  setup do
    @grammar = 
      Grammar.new do
        class NonterminalSymbolBuilder  
          def build
            nonterminal_symbol
          end
          
          def nonterminal_symbol
            seq(alpha_char, zero_or_more(alphanumeric_char)) do
              def value(grammar)
                grammar.nonterminal_symbol(name)
              end
              
              def name
                text_value.to_sym
              end
            end
          end
          
          def alpha_char
            char_class('A-Za-z')
          end
          
          def numeric_char
            char_class('0-9')
          end
          
          def alphanumeric_char
            choice(alpha_char, numeric_char)
          end
        end
        
        rule :nonterminal_symbol, NonterminalSymbolBuilder.new
      
        class TerminalSymbolBuilder
          module TerminalSymbolSyntaxNode
            def prefix
              elements[1].text_value
            end
            
            def value(grammar=nil)
              TerminalSymbol.new(prefix)
            end
          end
          
          def build
            choice(single_quoted_string, double_quoted_string)
          end
          
          def double_quoted_string
            seq('"', zero_or_more(double_quoted_string_char), '"') do
              include TerminalSymbolSyntaxNode
            end
          end
          
          def double_quoted_string_char
            seq(notp('"'), choice(seq('\\', '"'), any))
          end
          
          def single_quoted_string
            seq("'", zero_or_more(single_quoted_string_char), "'") do
              include TerminalSymbolSyntaxNode
            end
          end
          
          def single_quoted_string_char
            seq(notp("'"), choice(seq("\\", "'"), any))
          end
        end
        
        rule :terminal_symbol, TerminalSymbolBuilder.new
      end
    @parser = @grammar.new_parser
  end
  
  specify "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    @grammar.root = @grammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    @grammar.root = @grammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse('"foo"').value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    @grammar.root = @grammar.nonterminal_symbol(:nonterminal_symbol)
    syntax_node = @parser.parse('foo')    

    grammar = Grammar.new
    nonterminal = syntax_node.value(grammar)
    nonterminal.should_be_an_instance_of NonterminalSymbol
    nonterminal.name.should_equal :foo
    grammar.nonterminal_symbol(:foo).should_equal(nonterminal)
  end
end