require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "An alternative" do
  setup do
    @alternative = Alternative.new([])
  end
  
  specify "returns an empty exclusive methods module if no exclusive methods block has been set" do
    mod = @alternative.exclusive_methods_module
    mod.should_be_an_instance_of Module
    mod.instance_methods.should_be_empty
  end

  specify "returns an exclusive methods module with methods defined a block passed to def_exclusive_method" do
    @alternative.def_exclusive_methods do
      def exclusive_method
        "foo"
      end
    end
    
    mod = @alternative.exclusive_methods_module
    mod.should_be_an_instance_of Module
    mod.instance_methods.should_include "exclusive_method"
  end
end

context "An alternative with two nonterminal children" do
  setup do
    @first_nonterminal = mock("First nonterminal")
    @second_nonterminal = mock("Second nonterminal")
    
    containing_nonterminal = mock("Containing nonterminal")
    containing_nonterminal.should_receive(:get_sibling).with(:First).and_return(@first_nonterminal)
    containing_nonterminal.should_receive(:get_sibling).with(:Second).and_return(@second_nonterminal)
    
    @alternative = Alternative.new([:First, :Second])
    @alternative.containing_nonterminal = containing_nonterminal
  end
    
  specify "gets nonterminal classes for nonterminal symbols on call to children method" do
    @alternative.children.should_eql([@first_nonterminal, @second_nonterminal])
  end
  
  specify "advances parsing index correctly and returns correct values on parse_at" do    
    parser_instance = mock("Parser instance")
    @second_nonterminal.should_receive(:parse_at).with(5, :string, parser_instance).and_return(ParseResult.new("value2", 5, 10))
    @first_nonterminal.should_receive(:parse_at).with(0, :string, parser_instance).and_return(ParseResult.new("value1", 0, 5))
    
    parse_result = @alternative.parse_at(0, "irrelevant string because of nonterminal mocks", parser_instance)
    parse_result.value.should_eql ["value1", "value2"]
    parse_result.end_index.should_equal 10
  end
end

context "An alternative with a terminal child" do
  setup do
    @parser_instance = mock("Parser instance")
    containing_nonterminal = mock("Containing nonterminal that shouldn't be called")
    @alternative = Alternative.new(["foo"])
    @alternative.containing_nonterminal = containing_nonterminal
  end
  
  specify "updates the index appropriately during parse and returns a singleton array as a value" do
    parse_result = @alternative.parse_at(0, "foobar", @parser_instance_mock)
    parse_result.value.should_eql ["foo"]
    parse_result.end_index.should_equal 3
  end
  
  specify "fails and does not advance index on unmatching input" do
    parse_result = @alternative.parse_at(0, "bazbar", @parser_instance_mock)
    parse_result.should_be_failure
    parse_result.end_index.should_equal 0
  end
end

context "An alternative with multiple terminal children" do
  setup do
    containing_nonterminal = mock("Containing nonterminal")
    @alternative = Alternative.new(["foo", "bar", "baz"])
    @alternative.containing_nonterminal = containing_nonterminal    
    @parser_instance_mock = mock("Parser instance")
  end  
  
  specify "updates the index appropriately during parse and returns a singleton array as a value" do
    parse_result = @alternative.parse_at(0, "foobarbaz", @parser_instance_mock)
    parse_result.value.should_eql ["foo", "bar", "baz"]
    parse_result.end_index.should_equal 9
  end
end