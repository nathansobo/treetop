require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'benchmark'

class CircularCompilationTest < CompilerTestCase



  it "the generated metagrammar parser can parse the treetop file whence it came" do
    parser = Compiler2::Metagrammar.new
    File.open(METAGRAMMAR_2_PATH, 'r') do |file|
      input = file.read
      result = parser.parse(input)
      
      #puts result.nested_failures
      
    end
    
    # Object.class_eval(ruby_code)
    # new_parser = ::Treetop2::Compiler2::Metagrammar.new
    #   
    #   
    # File.open(METAGRAMMAR_2_PATH, 'r') do |metagrammar_file|
    #   input = metagrammar_file.read
    #   
    #   # Benchmark.bm(10) do |x|
    #   #   x.report("parsing metagrammar") do
    #       @result = new_parser.parse(input)
    #   #   end
    #   # end
    #   
    #   puts @result.nested_failures
    #   
    #   puts @result.compile
    # end
  end
end