require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the anything_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :anything_symbol
  end

  it "parses . as an AnythingSymbol" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|      
      char_class = parser.parse('.').value
      char_class.should be_an_instance_of(AnythingSymbol)
    end
  end
end