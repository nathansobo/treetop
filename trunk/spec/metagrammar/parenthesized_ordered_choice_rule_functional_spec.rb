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
    @node.to_ruby(grammar_node_mock).should == "TerminalSymbol.new('foo')"
  end
end

describe "In the Metagrammar only, the node returned by the parenthesized_ordered_choice rule's successful parsing of a parenthesized sequence followed by a Ruby block" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:parenthesized_ordered_choice) do |parser|
      @node = parser.parse("('foo' 'bar') {\ndef a_method\nend\n}")
    end
  end
  
  it "has the Ruby source representation of the sequence followed by the block" do
    @node.to_ruby(grammar_node_mock).should == "Sequence.new([TerminalSymbol.new('foo'), TerminalSymbol.new('bar')]) do\ndef a_method\nend\nend"
  end
end