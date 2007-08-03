require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Zero or more of a terminal symbol" do
  testing_expression '"foo"*'

  it "successfully parses epsilon with a nested failure" do
    parse('') do |result|
      result.should be_success
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 0
      nested_failure.expected_string.should == 'foo'
    end
  end
  
  it "successfully parses two of that terminal in a row, with a nested failure representing the third attempt" do
    parse("foofoo") do |result|
      result.should be_success
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures.first
      nested_failure.index.should == 6
      nested_failure.expected_string.should == 'foo'
    end
  end
end

describe "Zero or more of a sequence" do
  testing_expression '("foo" "bar")*'
  
  it "resets the index appropriately following partially matcing input" do
    parse('foobarfoo') do |result|
      result.should be_success
      result.interval.should == (0...6)
    end
  end
end