require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "An unadorned expression inside of parentheses", :extend => CompilerTestCase do
  testing_expression '("foo")'
  
  it "should behave as normal" do
    parse('foo').should be_success
  end
end

describe "A prefixed-expression inside of parentheses", :extend => CompilerTestCase do
  testing_expression '(!"foo")'
  
  it "should behave as normal" do
    parse('foo').should_not be_success
  end
end