require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'benchmark'

class CircularCompilationTest < CompilerTestCase
  test "the generated metagrammar parser can parse the treetop file whence it came" do
    File.open(METAGRAMMAR_2_PATH, 'r') do |file|
      input = file.read
      result = Treetop::Compiler::Metagrammar.new.parse(input)
      result.should be_success
            
      Treetop::Compiler.send(:remove_const, :Metagrammar)
      Object.class_eval(result.compile)
      
      Treetop::Compiler::Metagrammar.new.parse(input).should be_success
    end
  end
end