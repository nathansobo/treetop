dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "The a parser for the Protometagrammar" do
  before do
    @parser = Protometagrammar.new.new_parser
  end
  
  it "can parse the metagrammar" do

    metagrammar_file_path =
      File.expand_path('metagrammar.treetop', "#{File.dirname(__FILE__)}/../../lib/treetop/metagrammar/")
    
    File.open(metagrammar_file_path, 'r') do |file|
      result = @parser.parse(file.read)
      result.should be_success
      result.value.should be_an_instance_of(Grammar)
    end
  end
end