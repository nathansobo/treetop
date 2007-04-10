require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the primary rule" do
  include MetagrammarSpecContextHelper

  setup do
    @root = :primary
  end

  specify "parses an expression followed immediately by a + as one or more of that expression" do
    with_both_protometagrammar_and_metagrammar do
      result = parse_result_for('"b"+')
      result.should be_an_instance_of(OneOrMore)      
    end
  end

  specify "parses a nonterminal, string terminal, anything character, or character class" do
    with_both_protometagrammar_and_metagrammar do
      grammar = Grammar.new

      @parser.parse("'foo'").value(grammar).should_be_an_instance_of TerminalSymbol
      @parser.parse('foo').value(grammar).should_be_an_instance_of NonterminalSymbol
      @parser.parse('.').value(grammar).should_be_an_instance_of AnythingSymbol
      @parser.parse('[abc]').value(grammar).should_be_an_instance_of CharacterClass      
    end
  end

  specify "parses an &-predication" do
    with_both_protometagrammar_and_metagrammar do
      result = parse_result_for('&"foo"')

      result.should be_instance_of(AndPredicate)      
    end
  end

  specify "parses a !-predication" do
    with_both_protometagrammar_and_metagrammar do
      result = parse_result_for('!"foo"')

      result.should be_instance_of(NotPredicate)      
    end
  end

  specify "parses suffixes with higher precedence than prefixes" do
    with_both_protometagrammar_and_metagrammar do
      result = parse_result_for('!"foo"+')

      result.should be_instance_of(NotPredicate)
      result.expression.should be_instance_of(OneOrMore)      
    end
  end
  
  specify "parses a parenthesized terminal symbol followed by a block with the block bound to that terminal" do
    with_both_protometagrammar_and_metagrammar do
      result = @parser.parse("( 'foo' ) {\n  def a_method\n  end\n}")
      result.should be_success
    
      terminal = result.value(Grammar.new)
      terminal.should be_instance_of(TerminalSymbol)
      terminal.node_class.instance_methods.should include('a_method')      
    end
  end
  
  specify "parses a parenthesized sequence ending in a terminal symbol followed by a block with the block bound to that sequence" do
    with_both_protometagrammar_and_metagrammar do
      result = @parser.parse("( 'foo' 'bar' 'baz' ) {\n  def a_method\n  end\n}")
      result.should be_success
    
      sequence = result.value(Grammar.new)
      sequence.should be_instance_of(Sequence)
      sequence.node_class.instance_methods.should include('a_method')      
    end
  end
  
  specify "raises when a block follows a non-node-instantiating parenthesized expression is followed by a block" do
    with_both_protometagrammar_and_metagrammar do
      result = @parser.parse("( 'foo' / 'bar' / 'baz' ) {\n  def a_method\n  end\n}")
    
      lambda do
        result.value(Grammar.new)
      end.should_raise RuntimeError      
    end
  end
end