dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A parsing expression" do
  before do
    @expression = ParsingExpression.new
  end
  
  it "returns a ZeroOrMore parsing expression with itself as the repeated expression on call to zero_or_more" do
    zero_or_more = @expression.zero_or_more
    zero_or_more.should be_an_instance_of(ZeroOrMore)
    zero_or_more.repeated_expression.should == @expression
  end
  
  it "returns a OneOrMore parsing expression with itself as the repeated expression on call to one_or_more" do
    zero_or_more = @expression.one_or_more
    zero_or_more.should be_an_instance_of(OneOrMore)
    zero_or_more.repeated_expression.should == @expression
  end
  
  it "returns an Optional parsing expression with itself as the repeated expression on call to one_or_more" do
    optional = @expression.optional
    optional.should be_an_instance_of(Optional)
    optional.expression.should == @expression
  end
  
  it "returns an AndPredicate parsing expression with itself as the predicated expression on call to and_predicate" do
    and_predicate = @expression.and_predicate
    and_predicate.should be_an_instance_of(AndPredicate)
    and_predicate.expression.should == @expression
  end
  
  it "returns a NotPredicate parsing expression with itself as the predicated expression on call to not_predicate" do
    and_predicate = @expression.not_predicate
    and_predicate.should be_an_instance_of(NotPredicate)
    and_predicate.expression.should == @expression
  end  
end