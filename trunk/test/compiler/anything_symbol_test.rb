dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class AnythingSymbolTest < CompilerTestCase  
  class Foo < Treetop::Parser::SyntaxNode
  end
  
  testing_expression_2 '. <Foo> { def a_method; end }'
  
  it "matches any single character in a big range, returning an instance of the declared node class that responds to methods defined in the inline module" do
    (33..127).each do |digit|
      parse(digit.chr) do |result|
        result.should be_success
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (0...1)
      end
    end
  end
  
  it "fails to parse epsilon" do
    parse('').should be_failure
  end
end