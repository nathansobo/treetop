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
  
  it "can collect nested failures out of nested results with nested failures at the same index" do
    result_1 = parse_success_with_nested_failure_at(2)
    result_2 = terminal_parse_failure_at(2)
    nested_results = [result_1, result_2]
        
    nested_failures = @expression.send(:collect_nested_failures, nested_results)
        
    nested_failures.size.should == 2
    nested_failures.should include(result_1.nested_failures.first)
    nested_failures.should include(result_2)    
  end
end