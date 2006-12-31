require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

include Treetop

context "A new nonterminal" do
  setup do
    @nonterminal = Nonterminal::create_nonterminal_class(:Foo, mock("Containing parser"))
  end
  
  specify "has its name set by creation method" do
    @nonterminal.name.should_equal(:Foo)
  end
  
  specify "sets itself as the containing nonterminal when adding alternatives" do
    alternative = Alternative.new([:Foo])
    @nonterminal.add_alternative(alternative)
    @nonterminal.alternatives[0].containing_nonterminal.should_equal(@nonterminal)
  end
  
  specify "reports that it is a nonterminal" do
    @nonterminal.should_be_nonterminal
  end
  
  specify "reports that is is not a terminal" do
    @nonterminal.should_not_be_terminal
  end
end

context "A nonterminal with a sibling" do
  setup do
    containing_parser = mock("Containing parser")
    @nonterminal = Nonterminal::create_nonterminal_class(:FirstNonterminal, containing_parser)
    @other_nonterminal = Nonterminal::create_nonterminal_class(:OtherNonterminal, containing_parser)
    containing_parser.should_receive(:get_nonterminal).with(:Sibling).and_return(@other_nonterminal)
  end
  
  specify "returns that sibling when asked for by name" do
    @nonterminal.get_sibling(:Sibling).should_equal(@other_nonterminal)
  end
end

context "A nonterminal with shared method definitions and two alternatives with exclusive method definitions" do
  setup do    
    @containing_parser = mock("Containing parser")

    @alternative_1 = mock("First alternative")
    @alternative_1.should_receive(:containing_nonterminal=)
        
    @alternative_2 = mock("Second alternative") 
    @alternative_2.should_receive(:containing_nonterminal=)
    
    @nonterminal = Nonterminal::create_nonterminal_class(:Foo, @containing_parser)
    
    @nonterminal.add_alternative(@alternative_1)
    @nonterminal.add_alternative(@alternative_2)
    
    @node_cache = mock("Node cache")
    
    @parser_instance = mock("Parser instance")
    @parser_instance.should_receive(:node_cache).any_number_of_times.and_return(@node_cache)
    
    @nonterminal.def_shared_methods do
      def self.class_method
        "class_method"
      end
      
      def instance_method
        "instance method"
      end
    end
    
    @alternative_2.should_receive(:exclusive_methods_module).and_return(Module.new do
      def exclusive_method
        "foo"
      end
    end)
  end
    
  specify "returns an instance of itself based on the successful result of the second alternative if the first fails" do
    alternative_2_result = ParseResult.new(["child", "child"], 0, 5)
    @alternative_1.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(failure_at(0))
    @alternative_2.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(alternative_2_result)
    @node_cache.should_receive(:node_starting_at).with(@nonterminal.name, 0).and_return(nil)
    @node_cache.should_receive(:store_node)

    parse_result = @nonterminal.parse_at(0, "buffer contents", @parser_instance)
    parse_result.value.should_be_an_instance_of(@nonterminal)
    parse_result.value.children.should_eql(["child", "child"])
  end

  specify "returns a result with instance and class methods defined in a shared methods block associated with the nonterminal" do 
    alternative_2_result = ParseResult.new(["child", "child"], 0, 5)
    @alternative_1.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(failure_at(0))
    @alternative_2.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(alternative_2_result)
    @node_cache.should_receive(:node_starting_at).with(@nonterminal.name, 0).and_return(nil)
    @node_cache.should_receive(:store_node)
            
    parse_result = @nonterminal.parse_at(0, "buffer contents", @parser_instance)
    parse_result.value.class.should_respond_to :class_method
    parse_result.value.should_respond_to :instance_method
  end

  specify "returns a result with instance methods defined in an exclusive methods block associated with the successfully parsed alternative" do
    alternative_2_result = ParseResult.new(["child", "child"], 0, 5)
    @alternative_1.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(failure_at(0))
    @alternative_2.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(alternative_2_result)
    @node_cache.should_receive(:node_starting_at).with(@nonterminal.name, 0).and_return(nil)
    @node_cache.should_receive(:store_node)
      
    parse_result = @nonterminal.parse_at(0, "buffer contents", @parser_instance)
    parse_result.value.should_respond_to :exclusive_method
  end
  
  specify "stores a successful parse result in the node cache before returning it" do
    alternative_2_result = ParseResult.new(["child", "child"], 0, 5)
    @alternative_1.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(failure_at(0))
    @alternative_2.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(alternative_2_result)
    
    @node_cache.should_receive(:node_starting_at).with(@nonterminal.name, 0).and_return(nil)
    @node_cache.should_receive(:store_node) { |nonterminal_name, parse_result|
      nonterminal_name.should_equal(@nonterminal.name)
      parse_result.value.should_be_an_instance_of @nonterminal
    }
    
    @nonterminal.parse_at(0, "buffer contents", @parser_instance)
  end
  
  specify "retrieves its result from the node cache on the second call to parse_at at the same index" do
    alternative_2_result = ParseResult.new(["child", "child"], 0, 5)
    @alternative_1.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(failure_at(0))
    @alternative_2.should_receive(:parse_at).with(0, "buffer contents", @parser_instance).and_return(alternative_2_result)
    
    @node_cache.should_receive(:store_node) { |nonterminal_name, parse_result|
      nonterminal_name.should_equal(@nonterminal.name)
      parse_result.value.should_be_an_instance_of @nonterminal
    }
    cached_result = mock("Cached result")
    @node_cache.should_receive(:node_starting_at).once.with(@nonterminal.name, 0).and_return(nil, cached_result)
    
    @nonterminal.parse_at(0, "buffer contents", @parser_instance)
    result = @nonterminal.parse_at(0, "buffer contents", @parser_instance)
    result.should_equal(cached_result)
  end
end

def failure_at(index)
  ParseResult.new_failure(0)
end
  
context "A nonterminal with shared method definitions" do
  setup do
    containing_parser = mock("Containing parser")
    @nonterminal = Nonterminal::create_nonterminal_class(:Foo, containing_parser)
    @nonterminal.def_shared_methods do
      def self.class_method
        "class_method"
      end
      
      def instance_method
        "instance method"
      end
    end
  end
  
end


