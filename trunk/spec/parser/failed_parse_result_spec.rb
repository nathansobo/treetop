require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new failed parse result" do
  setup do
    @result = FailedParseResult.new
  end
  
  specify "is a failure" do
    @result.should be_a_failure
    @result.should_not be_a_success
  end
end