require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A sequence of terminal symbols" do
  testing_expression '"foo" "bar" "baz"'
  
  it "parses matching input successfully" do
    parse('foobarbaz') do |result|
      result.should be_success
      result.should be_an_instance_of(SequenceSyntaxNode)
      (result.elements.map {|elt| elt.text_value}).join.should == 'foobarbaz'
    end
  end
  
  it "parses matching input at a non-zero index successfully" do
    parse('---foobarbaz', :at_index => 3) do |result|
      result.should be_success
      result.should be_an_instance_of(SequenceSyntaxNode)
      (result.elements.map {|elt| elt.text_value}).join.should == 'foobarbaz'
    end
  end
  
  it "fails to parse non-matching input with a nested failure at the first terminal that did not match" do
    parse('---foobazbaz', :at_index => 3) do |result|
      result.should be_failure
      result.index.should == 3
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'bar'
    end
  end
end

describe "A sequence of terminal symbols followed by a node class declaration" do

  testing_expression '"foo" "bar" "baz" <NodeClass>'
  
  it "parses successfully" do
    # nothing for now
  end
end