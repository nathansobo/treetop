dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the metagrammar" do
  include MetagrammarSpecContextHelper
  
  before do
    @parser = parser_for_metagrammar
  end
  
  it "can parse the metagrammar" do

    metagrammar_file_path =
      File.expand_path('metagrammar.treetop', "#{File.dirname(__FILE__)}/../../lib/treetop/metagrammar/")
    
    File.open(metagrammar_file_path, 'r') do |file|
      result = @parser.parse(file.read)
      result.should be_success
    end
  end
end