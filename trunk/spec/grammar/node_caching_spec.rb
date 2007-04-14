require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A sequence" do
  setup do
    @sequence = Sequence.new([])
    @parser = mock("parser")
    @node_cache = mock("node cache")    
  end
  
  specify "has a node cache stored in the parser" do
    @parser.should_receive(:node_cache_for).with(@sequence).and_return(@node_cache)
    @sequence.node_cache(@parser).should == @node_cache
  end
  
  specify "checks its cache for a node stored at an consumed_interval beginning at the start index" do
    start_index = 0
    @sequence.stub!(:node_cache).and_return(@node_cache)    
    stored_node = mock("node previously stored in the cache at consumed_interval starting at start_index")
    @node_cache.should_receive(:[]).with(start_index).and_return(stored_node)

    @sequence.parse_at(mock('input'), start_index, @parser).should equal(stored_node)
  end
  
  specify "stores parse results in its node cache before returning them" do
    start_index = 0
    input = mock("input")
    @sequence.stub!(:node_cache).and_return(@node_cache)    
    @node_cache.should_receive(:[]).with(start_index).and_return(nil)

    parse_result = mock('parse result')
    @sequence.stub!(:parse_at_without_caching).and_return(parse_result)
    
    @node_cache.should_receive(:store).with(parse_result).and_return(parse_result)
    @sequence.parse_at(input, start_index, @parser).should == parse_result
  end
  
#  specify "caches a node stored at the consumed_interval beginning at the start index" do
#  end
end