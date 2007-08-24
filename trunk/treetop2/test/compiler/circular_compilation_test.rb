require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'benchmark'

class CircularCompilationTest < CompilerTestCase
  def setup
    File.open(METAGRAMMAR_2_PATH, 'r') do |metagrammar_file|
      @result = parse_with_metagrammar(metagrammar_file.read, :treetop_file)
    end
  end

  it "can generate a metagrammar that can parse its own source" do
    ruby_code = @result.compile
    #puts ruby_code
    Object.class_eval(ruby_code)
    new_parser = ::Treetop2::Compiler2::Metagrammar.new


    File.open(METAGRAMMAR_2_PATH, 'r') do |metagrammar_file|
      input = metagrammar_file.read
      
      # Benchmark.bm(10) do |x|
      #   x.report("parsing metagrammar") do
          @result = new_parser.parse(input)
      #   end
      # end

      @result.should be_success
    end
  end
end