require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A grammar for treetop protogrammars" do
  setup do
    metagrammar = 
      Grammar.new do
        root :terminal_symbol
      
        class TerminalSymbolBuilder
          def build
            choice(single_quoted_string, double_quoted_string)
          end
          
          def double_quoted_string
            seq('"', zero_or_more(double_quoted_string_char), '"')
          end
          
          def double_quoted_string_char
            seq(not('"'), choice(seq('\\', '"'), anything))
          end
          
          def single_quoted_string
            seq("'", zero_or_more(single_quoted_string_char), "'")
          end
          
          def single_quoted_string_char
            seq(not("'"), choice(seq("\\", "'"), anything))
          end
        end
        
        rule :terminal_symbol, TerminalSymbolBuilder
        
      end
    @parser = metagrammar.new_parser
  end
  
  specify "parses a single quoted string as a TerminalSymbol with the correct prefix value" do
    terminal = parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
end