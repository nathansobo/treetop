require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module ParenthesizedExpressionSpec
  describe "An unadorned expression inside of parentheses" do
    testing_expression '("foo")'
  
    it "should behave as normal" do
      parse('foo').should be_success
    end
  end

  describe "A prefixed-expression inside of parentheses" do
    testing_expression '(!"foo")'
  
    it "should behave as normal" do
      parse('foo').should_not be_success
    end
  end
end
