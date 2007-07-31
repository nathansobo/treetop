require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A choice between terminal symbols" do
  testing_expression '"foo" / "bar" / "baz"'

  it "successfully parses input matching any of the alternatives" do
    parse('foo').should be_success
    parse('foo').should be_success
    parse('foo').should be_success
  end

end