dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the sequence rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:sequence)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_global_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a sequence of terminals" do
    result = @parser.parse("'a' 'b' 'c'")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].prefix.should == 'a'
    value.elements[1].prefix.should == 'b'
    value.elements[2].prefix.should == 'c'
  end
  
  it "successfully parses and generates Ruby for a sequence of labeled nonterminals" do
    result = @parser.parse("label_a:a label_b:b label_c:c")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].name.should == :a
    value.elements[0].label.should == :label_a
    value.elements[1].name.should == :b
    value.elements[1].label.should == :label_b
    value.elements[2].name.should == :c
    value.elements[2].label.should == :label_c
  end
  
  it "does not parse a sequence containing an unparenthesized terminal followed by a block" do
    result = @parser.parse("'a' { def a_method; end } 'b' 'c'")
    result.should be_failure
  end
  
  it "successfully parses a sequence containing a parenthesized terminal followed by a block" do
    result = @parser.parse("('a' { def a_method; end }) 'b' 'c'")
    result.should be_failure
  end

  it "successfully parses a sequence of terminals followed by a block, associating the block with the sequence and not the last terminal" do
    result = @parser.parse("'a' 'b' 'c' { def a_method; end }")        
    result.should be_success
    
    value = eval(result.to_ruby(@grammar_node_mock))
    value.node_class.instance_methods.should include('a_method')
  end

  it "successfully parses a sequence of terminals followed by a node class expression and a Ruby block" do    
    Object.class_eval do
      class TestNodeClass < SequenceSyntaxNode
      end
    end
    
    result = @parser.parse("'a' 'b' 'c' <TestNodeClass> { def a_method; end }")
    result.should be_success
    
    value = eval(result.to_ruby(@grammar_node_mock))
    value.node_class.should == TestNodeClass
    value.node_class.instance_methods.should include('a_method')
    
    teardown_global_constant(:TestNodeClass)
  end
  
  
  it "successfully parses and generates Ruby for a sequence of parenthesized choices" do
    result = @parser.parse("(a / b) (c / d) (e / f)")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].should be_an_instance_of(OrderedChoice)
  end
  
  it "successfully parses a sequence of nonterminals followed by a block" do
    @parser.parse("a b c { def a_method; end }")
  end
end