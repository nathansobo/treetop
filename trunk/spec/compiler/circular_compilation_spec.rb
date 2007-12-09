require File.join(File.dirname(__FILE__), '..', 'spec_helper')
BENCHMARK = false

module CircularCompilationSpec
  describe "a parser for the metagrammar" do
    attr_reader :parser
    
    before do
      @parser = Treetop::Compiler::MetagrammarParser.new
    end
    
    it "can parse the metagrammar.treetop whence it was generated" do
      File.open(METAGRAMMAR_PATH, 'r') do |f|
        optionally_benchmark do
          result = parser.parse(f.read)
          result.should be_success
        end
      end
    end
  end
end
