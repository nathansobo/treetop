dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The second-generation Metagrammar, produced by evaluating the results of the first generation Metagrammar's parsing of metagrammar.treetop" do
  include MetagrammarSpecContextHelper
  
  before do
    gen_2_results = parse_metagrammar_with(parser_for_metagrammar)
    eval("module SecondGeneration\n#{gen_2_results.to_ruby}\nend")
    @gen_2_parser = SecondGeneration::Treetop::Metagrammar.new_parser
  end
  
  it "can parse metagrammar.treetop and generate a third-generation Metagrammar" do
    
    gen_3_result = parse_metagrammar_with(@gen_2_parser)
    eval("module ThirdGeneration\n#{gen_3_result.to_ruby}\nend")
    
    ThirdGeneration::Treetop::Metagrammar.should be_an_instance_of(Grammar)
  end
  
  def parse_metagrammar_with(grammar)
    metagrammar_file_path =
      File.expand_path('metagrammar.treetop', "#{File.dirname(__FILE__)}/../../lib/treetop/metagrammar/")

    File.open(metagrammar_file_path, 'r') do |file|
      return grammar.parse(file.read)
    end
  end
end