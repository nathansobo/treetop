dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SyntaxNode, " instantiated without encountered results" do
  before do
    @node = SyntaxNode.new(mock("input"), mock("interval"))
  end
  
  it "should be success" do
    @node.should be_success
  end
  
  it "should not be failure" do
    @node.should_not be_failure
  end
  
  it "should not be epsilon" do
    @node.should_not be_epsilon
  end
  
  it "has no nested failures" do
    @node.nested_failures.should == []
  end
end

describe SyntaxNode, " instantiated with results that have nested failures" do
  before do
    @result_1 = terminal_parse_failure_at(4)
    @result_2 = parse_failure_at_with_nested_failure_at(3, 4)
    @result_3 = parse_success_with_nested_failure_at(3)
    
    @nested_results = [@result_1, @result_2, @result_3]
    @node = SyntaxNode.new(mock('input'), mock('interval'), @nested_results)
  end
  
  it "has the nested failures with the highest index out of those results" do
    @node.nested_failures.should include(@result_1)
    @node.nested_failures.should include(@result_2.nested_failures.first)
  end
    
  it "retains its existing nested failures when updated with new encountered results with nested failures whose indices are less than the index of its existing nested failures" do
    
    new_result_1 = parse_failure_at_with_nested_failure_at(0, 1)
    new_result_2 = parse_failure_at_with_nested_failure_at(0, 2)
        
    nested_failures_before_update = @node.nested_failures.clone
    @node.update_nested_failures([new_result_1, new_result_2])
    
    @node.nested_failures.should == nested_failures_before_update
  end
  
  it "adds to existing nested failures if updated with a set of existing failures with a maximum index equal to the existing maximum index" do
    new_result = parse_failure_at_with_nested_failure_at(0, 4)
    
    pre_update_nested_failure_count = @node.nested_failures.size
    @node.update_nested_failures([new_result])
    @node.nested_failures.size.should == pre_update_nested_failure_count + 1
    @node.nested_failures.should include(new_result.nested_failures.first)
  end
end