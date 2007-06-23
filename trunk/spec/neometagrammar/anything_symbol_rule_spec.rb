dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the anything_symbol rule's the successful parsing of a . character" do
  include NeometagrammarSpecContextHelper
  
  before(:all) do
    with_metagrammar(:anything_symbol) do |parser|
      @node = parser.parse('.')
    end
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to an AnythingSymbol" do
    value = eval(@node.to_ruby)
    value.should be_an_instance_of(AnythingSymbol)
  end
end