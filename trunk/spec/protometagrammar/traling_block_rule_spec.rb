dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the Protometagrammar rooted at the trailing_block rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :trailing_block
  end
  
  it "parses space followed by a node_class_eval block as a node that evaluates the textual value of the block in the node class of the preceding expression" do
    with_protometagrammar(@root) do |parser|
      block_contents = "\ndef a_method\n\nend\n"
      result = parser.parse("   {#{block_contents}}")
      result.should be_success
        
      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_receive(:node_class_eval).with(block_contents)
    
      result.value(parsing_expression).should == parsing_expression
    end
  end
  
  it "parses nothing as a node that passes the value of the preceding expression through unchanged" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("")
      result.should be_success

      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_not_receive(:node_class_eval)

      result.value(parsing_expression).should == parsing_expression
    end
  end
end
