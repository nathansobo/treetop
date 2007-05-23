dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the space rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :space
  end

  it "parses different types of whitespace" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      grammar = Grammar.new

      parser.parse(' ').should be_success
      parser.parse('    ').should be_success
      parser.parse("\t\t").should be_success
      parser.parse("\n").should be_success
    end
  end
  
  it "does not parse nonwhitespace characters" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      grammar = Grammar.new
      parser.parse('g').should be_failure
      parser.parse('g ').should be_failure
      parser.parse(" crack\n").should be_failure  
      parser.parse("\n rule foo\n bar\n end\n").should be_failure
    end
  end
end