require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "The result of the metagrammar parsing its own source" do

  before do
    File.open(METAGRAMMAR_PATH, 'r') do |metagrammar_file|
      @result = parse_with_metagrammar(metagrammar_file.read, :treetop_file)
    end
  end

  it "is successful and has a grammar element" do
    @result.should be_success
    (@result.elements.any? {|element| element.is_a?(Treetop2::Compiler::Grammar) }).should be_true
  end
end