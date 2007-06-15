dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "In the Metagrammar only, the node returned by the parenthesized_ordered_choice rule's successful parsing of a parenthesized terminal symbol" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:parenthesized_ordered_choice) do |parser|
      @node = parser.parse("('foo')")
    end
  end
  
  it "has the Ruby source representation of the parenthesized terminal as its source representation" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == 'foo'
  end
end

describe "In the Metagrammar only, the node returned by the parenthesized_ordered_choice rule's successful parsing of a parenthesized sequence followed by a Ruby block" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:parenthesized_ordered_choice) do |parser|
      @node = parser.parse("('foo' 'bar') {\ndef a_method\nend\n}")
    end
  end
  
  it "has a Ruby source representation that evaluates to the sequence with the method block from the block defined on its node class" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.node_class.instance_methods.should include('a_method')
  end
end