dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the sequence rule's successful parsing of space-separated terminals" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("'foo' 'bar' 'baz'")
    end
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to a sequence expression" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.parse_at('foobarbaz', 0, parser_with_empty_cache_mock).should be_success
  end
end

describe "The node returned by the sequence rule's successful parsing of space-separated terminals and nonterminals" do
  include MetagrammarSpecContextHelper

  before(:all) do
    Bar = Grammar.new
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("'foo' bar baz")
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Bar)
  end

  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to a sequence expression" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    value.should be_an_instance_of(Sequence)
    value.elements[0].prefix.should == 'foo'
    value.elements[1].name.should == :bar
    value.elements[2].name.should == :baz
  end
end

describe "The node returned by the sequence rule's parsing of a sequence followed by a block" do
  include MetagrammarSpecContextHelper

  before(:all) do
    Bar = Grammar.new    
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("foo bar {\ndef a_method\n\nend\n}")
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Bar)
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to a sequence with the method from the block defined on its node class" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    value.should be_an_instance_of(Sequence)
    value.node_class.instance_methods.should include('a_method')
  end
end

describe "The node returned by the sequence rule's successful parsing an unparenthesized sequence ending in a terminal followed by a block" do
  include MetagrammarSpecContextHelper

  before(:all) do
    Bar = Grammar.new    
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("foo 'bar' {\ndef a_method\n\nend\n}")
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Bar)
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that defines the method from the block in the node class of the final terminal, not the sequence" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))    
    value.node_class.instance_methods.should_not include('a_method')
    value.elements[1].node_class.instance_methods.should include('a_method')
  end
end

describe "The node returned by the sequence rule's parsing of a sequence ending in a parenthesized nonterminal followed by a block" do
  include MetagrammarSpecContextHelper

  before(:all) do
    Bar = Grammar.new    
    with_gen_1(:sequence) do |parser|
      @node = parser.parse("foo (bar) {\ndef a_method\n\nend\n}")
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Bar)
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to a sequence with the method from the block defined on its node class" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    value.should be_an_instance_of(Sequence)
    value.node_class.instance_methods.should include('a_method')
  end
end
