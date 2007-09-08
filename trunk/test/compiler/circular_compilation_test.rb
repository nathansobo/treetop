require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'benchmark'

class CircularCompilationTest < CompilerTestCase
  test "the generated metagrammar parser can parse the treetop file whence it came" do
    File.open(METAGRAMMAR_PATH, 'r') do |file|
      input = file.read
      result = Treetop::Compiler::MetagrammarParser.new.parse(input)
      result.should be_success
            
      Treetop::Compiler.send(:remove_const, :Metagrammar)
      parser_code = result.compile
      Object.class_eval(parser_code)
      
      r = Treetop::Compiler::MetagrammarParser.new.parse(input)
      r.should be_success
    end
  end
end