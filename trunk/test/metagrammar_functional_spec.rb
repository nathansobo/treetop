require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A grammar for treetop protogrammars" do
  setup do
    grammar = 
      Grammar.new do
        root :terminal_symbol
      
        class TerminalSymbolBuilder
          module TerminalSymbolSyntaxNode
            def prefix
              elements[1].text_value
            end
            
            def value
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
    @parser = grammar.new_parser
  end
  
  specify "parses a single quoted string as a TerminalSymbol with the correct prefix value" do
    terminal = @parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
end