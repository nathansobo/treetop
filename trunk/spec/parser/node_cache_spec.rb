require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new node cache" do
  setup do
    @node_cache = NodeCache.new
  end
  
  specify "is empty" do
    @node_cache.should be_empty
  end
end

context "A node cache with one stored parse result" do
  setup do
    @node_cache = NodeCache.new
    @interval = 7...29
    @parse_result = successful_parse_result_for(mock('a parsing expression'), @interval)
    @node_cache.store(@parse_result)
  end
  
  specify "returns that syntax node when queried at the start of its interval" do
    @node_cache[@interval.begin].should == @parse_result
  end
end