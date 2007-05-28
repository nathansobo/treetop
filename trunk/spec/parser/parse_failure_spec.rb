dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe ParseFailure do
  before do
    @matched_interval_begin = 0
    @parse_failure_forre = ParseFailure.new(@matched_interval_begin)
  end
  
  it "should be failure" do
    @parse_failure_forre.should be_failure
  end
  
  it "should not be success" do
    @parse_failure_forre.should_not be_success
  end 
  
  it "has a zero length interval at the beginning of its match interval" do
    @parse_failure_forre.interval.should == (@matched_interval_begin...@matched_interval_begin)
  end
  
  it "has an empty array of nested failures" do
    @parse_failure_forre.nested_failures.should == []
  end
end

describe ParseFailure, " instantiated with results that have nested failures" do
  before do
    @result_1 = terminal_parse_failure_at(4)
    @result_2 = parse_failure_at_with_nested_failure_at(3, 4)
    @result_3 = parse_success_with_nested_failure_at(3)
    
    @nested_results = [@result_1, @result_2, @result_3]
    @failure = ParseFailure.new(mock('interval'), @nested_results)
  end


  it "has the nested failures with the highest index out of those results" do
    @failure.nested_failures.should include(@result_1)
    @failure.nested_failures.should include(@result_2.nested_failures.first)
  end
end