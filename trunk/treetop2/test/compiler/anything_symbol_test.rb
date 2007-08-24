dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class AnythingSymbolFollowedByNodeClassDeclarationTest < CompilerTestCase  
  class Foo < Treetop2::Parser::SyntaxNode
  end
  
  testing_expression '. <Foo>'
  
  it "matches any single character in a big range, returning an instance of the declared node class" do
    (33..127).each do |digit|
      parse(digit.chr) do |result|
        result.should be_success
        result.should be_an_instance_of(Foo)
        result.interval.should == (0...1)
      end
    end
  end
  
  it "fails to parse epsilon" do
    parse('').should be_failure
  end
end