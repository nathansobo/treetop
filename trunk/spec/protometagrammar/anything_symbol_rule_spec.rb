dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_context_helper"

describe "The subset of the Protometagrammar rooted at the anything_symbol rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :anything_symbol
  end

  it "parses . as an AnythingSymbol" do
    with_protometagrammar(@root) do |parser|      
      char_class = parser.parse('.').value
      char_class.should be_an_instance_of(AnythingSymbol)
    end
  end
end
