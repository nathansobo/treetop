dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"


describe "The subset of the metagrammar rooted at the trailing_block rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :trailing_block
  end
  
  it "parses space followed by a node_class_eval block as a node that evaluates the textual value of the block in the node class of the preceding expression" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      block_contents = "\ndef a_method\n\nend\n"
      result = parser.parse("   {#{block_contents}}")
      result.should be_success
        
      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_receive(:node_class_eval).with(block_contents)
    
      result.value(parsing_expression).should == parsing_expression
    end
  end
  
  it "parses nothing as a node that passes the value of the preceding expression through unchanged" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("")
      result.should be_success

      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_not_receive(:node_class_eval)

      result.value(parsing_expression).should == parsing_expression
    end
  end
end

describe "In the Metagrammar only, the node returned by the trailing_block rule's successful parsing of a space and a Ruby block" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:trailing_block) do |parser|
      @ruby_block_contents = "\ndef a_method\n\nend\n"
      @node = parser.parse(" {#{@ruby_block_contents}}")
    end
  end
  
  it "has a Ruby source representation with that block subsequent to the Ruby representation of the preceding expression" do
    preceding_expression = mock('preceding expression')
    ruby_for_preceding_expression = 'TerminalSymbol.new("foo")'
    preceding_expression.should_receive(:to_ruby).and_return(ruby_for_preceding_expression)

    @node.to_ruby(preceding_expression).should == "#{ruby_for_preceding_expression} do#{@ruby_block_contents}end"
  end
end

describe "In the Metagrammar only, the node returned by the trailing_block rule's successful parsing of epsilon" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:trailing_block) do |parser|
      @node = parser.parse("")
    end
  end
  
  it "has a Ruby source representation identical to that of a given preceding expression" do
    preceding_expression = mock('preceding expression')
    ruby_for_preceding_expression = 'TerminalSymbol.new("foo")'
    preceding_expression.should_receive(:to_ruby).and_return(ruby_for_preceding_expression)

    @node.to_ruby(preceding_expression).should == ruby_for_preceding_expression
  end
end