require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A new node cache" do
  setup do
    @node_cache = NodeCache.new
  end
  
  it "is empty" do
    @node_cache.should be_empty
  end
end

describe "A node cache with one stored parse result" do
  setup do
    @node_cache = NodeCache.new
    @interval = 7...29
    @parse_result = successful_parse_result(@interval)
    @node_cache.store(@parse_result)
  end
  
  it "returns that syntax node when queried at the start of its interval" do
    @node_cache[@interval.begin].should == @parse_result
  end
end