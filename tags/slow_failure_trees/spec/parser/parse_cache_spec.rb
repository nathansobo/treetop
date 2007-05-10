require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An empty parse cache" do
  setup do
    @parse_cache = ParseCache.new
  end
  
  specify "lazily instantiates node caches for their corresponding parsing expressions" do
    sequence_expression = mock("sequence expression")
    @parse_cache.should be_empty
    node_cache = @parse_cache[sequence_expression]
    @parse_cache.should_not be_empty
    @parse_cache[sequence_expression].should == node_cache
  end
  
  specify "is empty" do
    @parse_cache.should be_empty
  end
end