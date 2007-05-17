require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An instance of NonterminalParseFailure" do
  setup do
    @matched_interval_begin = 1
    
    @nested_failure_1 = TerminalParseFailure.new(5, mock('terminal expression that failed'))
    @nested_failure_2 = TerminalParseFailure.new(3, mock('terminal expression that failed'))
    @nested_failures = [@nested_failure_1, @nested_failure_2]
    
    @parse_failure = NonterminalParseFailure.new(@matched_interval_begin, mock('nonterminal expression that failed'), @nested_failures)
  end
  
  it "has a matched_interval that begins at the supplied match_interval_begin and ends at the maximum matched_interval_end of the nested failures" do
    @parse_failure.matched_interval.should == (@matched_interval_begin...@nested_failure_1.matched_interval.end)
  end
  
  it "of those nested failures with which it is instantiated, propagates only those with the highest match interval end index" do
    @parse_failure.nested_failures.should == [@nested_failure_1]
  end
end

describe "An instance of NonterminalParseFailure with three nested failures, two of which have the same matched_interval.end" do
  setup do
    @matched_interval_begin = 1
    
    @nested_failure_1 = TerminalParseFailure.new(5, mock('terminal expression that failed'))
    @nested_failure_2 = TerminalParseFailure.new(5, mock('terminal expression that failed'))
    @nested_failure_3 = TerminalParseFailure.new(4, mock('terminal expression that failed'))
    @nested_failures = [@nested_failure_1, @nested_failure_2, @nested_failure_3]
    
    @parse_failure = NonterminalParseFailure.new(@matched_interval_begin, mock('nonterminal expression that failed'), @nested_failures)
  end
  
  it "has a matched_interval that begins at the supplied match_interval_begin and ends at the maximum matched_interval_end of the nested failures" do
    @parse_failure.matched_interval.should == (@matched_interval_begin...@nested_failure_1.matched_interval.end)
  end
  
  it "of those nested failures with which it is instantiated, propagates only those with the highest match interval end index" do
    @parse_failure.nested_failures.should == [@nested_failure_1, @nested_failure_2]
  end
  
end