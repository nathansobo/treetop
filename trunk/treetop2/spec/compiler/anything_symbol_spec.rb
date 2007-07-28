dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An anything symbol (.)" do
  
  testing_expression '.'
  
  it "matches any single character in a big range" do
    (33..127).each do |digit|
      parse(digit.chr) do |result|
        result.should be_success
        result.interval.should == (0...1)
      end
    end
  end
  
  it "fails to parse epsilon" do
    parse('').should be_failure
  end
end