require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module AnythingSymbolSpec
  class Foo < Treetop::Runtime::SyntaxNode
  end

  describe "an anything symbol followed by a node class declaration and a block" do
    testing_expression '. <AnythingSymbolSpec::Foo> { def a_method; end }'
  
    it "matches any single character in a big range, returning an instance of the declared node class that responds to methods defined in the inline module" do
      (33..127).each do |digit|
        parse(digit.chr) do |result|
          result.should_not be_nil
          result.should be_an_instance_of(Foo)
          result.should respond_to(:a_method)
          result.interval.should == (0...1)
        end
      end
    end

    it "returns a SyntaxNode with no dependencies upon a successful parse" do
      parse("x").dependencies.should be_empty
    end

    it "fails to parse epsilon" do
      parse('').should be_nil
    end
  end
end