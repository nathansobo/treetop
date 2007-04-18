require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An ordered choice parsing expression with three terminal alternatives" do
  setup do
    @alts = ["foo", "bar", "baz"]
    @choice = OrderedChoice.new(@alts.collect { |alt| TerminalSymbol.new(alt) })
  end
  
  specify "returns a SuccessfulParseResult with the value of the first alternative as its value if it succeeds" do
    result = @choice.parse_at(@alts[0], 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    result.value.text_value.should_eql @alts[0]
  end

  specify "has a string representation" do
    @choice.to_s.should == '("foo" / "bar" / "baz")'
  end
end

context "The result of an ordered choice with three terminal alternatives, if the second is successful" do
  setup do
    @alts = ["foo", "bar", "baz"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at(@alts[1].prefix, 0, parser_with_empty_cache_mock)
  end
  
  specify "is an instance SuccessfulParseResult" do
    @result.should be_an_instance_of(SuccessfulParseResult)
  end
  
  specify "has the parse result of the second terminal as its value" do
    value = @result.value
    value.should be_a_kind_of(TerminalSyntaxNode)
    value.text_value.should == @alts[1].prefix
  end
  
  specify "has a failure tree with the first terminal failure as a subtree" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.expression.should == @choice
    failure_tree.subtrees.size.should == 1
    failure_tree.subtrees.first.expression.should == @alts[0]
  end
end

context "The result of an ordered choice with three terminal alternatives, if the third is successful" do
  setup do
    @alts = ["foo", "bar", "baz"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at(@alts[2].prefix, 0, parser_with_empty_cache_mock)
  end
  
  specify "is an instance SuccessfulParseResult" do
    @result.should be_an_instance_of(SuccessfulParseResult)
  end
  
  specify "has the parse result of the third terminal as its value" do
    value = @result.value
    value.should be_a_kind_of(TerminalSyntaxNode)
    value.text_value.should == @alts[2].prefix
  end
  
  specify "has a failure tree with both previous failures as subtrees" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.expression.should == @choice
    failure_tree.subtrees.size.should == 2
    failure_tree.subtrees[0].expression.should == @alts[0]
    failure_tree.subtrees[1].expression.should == @alts[1]
  end
end

context "The result of an ordered choice with two terminal alternatives, if niether is successful" do
  setup do
    @alts = ["foo", "bar"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at('crapola', 0, parser_with_empty_cache_mock)
  end
  
  specify "is an instance FailedParseResult" do
    @result.should be_an_instance_of(FailedParseResult)
  end
    
  specify "has a failure tree with the failures of the alternatives as subtrees" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.expression.should == @choice
    failure_tree.subtrees.size.should == 2
    failure_tree.subtrees[0].expression.should == @alts[0]
    failure_tree.subtrees[1].expression.should == @alts[1]
  end
end