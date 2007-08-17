require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'benchmark'

describe "The result of the metagrammar parsing its own source" do

  before do
    File.open(METAGRAMMAR_PATH, 'r') do |metagrammar_file|
      # Benchmark.bm(100) do |x|
      #   x.report("parsing metagrammar") do
          @result = parse_with_metagrammar(metagrammar_file.read, :treetop_file)
      #   end
      # end
    end
  end

  it "is successful and has a grammar element" do
    @result.should be_success
    (@result.elements.any? {|element| element.is_a?(Treetop2::Compiler::Grammar) }).should be_true
  end
end