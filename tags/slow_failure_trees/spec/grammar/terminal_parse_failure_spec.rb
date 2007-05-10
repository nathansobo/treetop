require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of TerminalParseFailure" do
  setup do
    @matched_interval_begin = 5
    @parse_failure = TerminalParseFailure.new(@matched_interval_begin, mock('terminal expression that failed'))
  end
  
  specify "has a zero length matched_interval at the beginning of the match interval because it has no nested failures" do
    @parse_failure.matched_interval.should == (@matched_interval_begin...@matched_interval_begin)
  end
end