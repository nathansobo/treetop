dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the trailing_block rule's successful parsing of a space and a Ruby block" do
  include NeometagrammarSpecContextHelper
  
  before do
    with_metagrammar(:trailing_block) do |parser|
      @ruby_block_contents = "\ndef a_method\n\nend\n"
      @node = parser.parse(" {#{@ruby_block_contents}}")
    end
  end
  
  it "has a Ruby source representation with that block subsequent to the Ruby representation of the preceding expression" do
    ruby_for_preceding_expression = 'TerminalSymbol.new("foo")'
    @node.to_ruby(ruby_for_preceding_expression).should == "#{ruby_for_preceding_expression} do#{@ruby_block_contents}end"
  end
end

describe "The node returned by the trailing_block rule's successful parsing of epsilon" do
  include NeometagrammarSpecContextHelper
  
  before do
    with_metagrammar(:trailing_block) do |parser|
      @node = parser.parse("")
    end
  end
  
  it "has a Ruby source representation identical to that of a given preceding expression" do
    ruby_for_preceding_expression = 'TerminalSymbol.new("foo")'
    @node.to_ruby(ruby_for_preceding_expression).should == ruby_for_preceding_expression
  end
end