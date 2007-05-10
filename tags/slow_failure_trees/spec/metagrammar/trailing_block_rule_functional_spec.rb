require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"


context "The subset of the metagrammar rooted at the trailing_block rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :trailing_block
  end
  
  specify "parses space followed by a node_class_eval block as a node that can node class eval the block's contents on a preceding expression" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      block_contents = "\ndef a_method\n\nend\n"
      result = parser.parse("   {#{block_contents}}")
      result.should be_success
        
      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_receive(:node_class_eval).with(block_contents)
    
      result.value(parsing_expression).should == parsing_expression
    end
  end
  
  specify "parses nothing as a node that passes the value of the preceding expression through unchanged" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("")
      result.should be_success

      parsing_expression = mock('parsing expression preceding the block')
      parsing_expression.should_not_receive(:node_class_eval)

      result.value(parsing_expression).should == parsing_expression
    end
  end
end