require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

include Treetop
include DefinesParsers

context "A new parser class" do
  setup do
    @parser_class = create_parser_class(:Parser)
  end
  
  specify "is an instance of Class" do
    @parser_class.should_be_an_instance_of Class
  end
end

context "A new parser class with one nonterminal" do
  setup do
    @parser_class = create_parser_class(:Parser)
    @parser_class.add_nonterminal :Foo
  end
    
  specify "is rooted at that nonterminal" do
    @parser_class.root.should_equal @parser_class::Foo
  end
  
  specify "allows access to that nonterminal via get_nonterminal" do
    @parser_class.get_nonterminal(:Foo).should_not_be_nil
    @parser_class.get_nonterminal(:Foo).should_equal @parser_class::Foo
  end
end

context "An instance of a parser class" do
  setup do
    @parser_class = create_parser_class(:Parser)
    @parser_instance = @parser_class.new
  end
  
  specify "has a node cache" do
    @parser_instance.node_cache.should_not_be_nil
  end
end

context "A kleene closure constructed for a parser's nonterminal node" do
  setup do
    @parser_class = create_parser_class(:Parser)
    @parser_class.add_nonterminal :Foo
    
    @kleene_nonterminal_sym = @parser_class.kleene_closure(:Foo)
    @kleene_nonterminal = @parser_class.get_nonterminal(@kleene_nonterminal_sym)
  end
  
  specify "is constructed successfully" do
    @kleene_nonterminal.should_not_be_nil
  end

  specify "is a nonterminal class" do
    @kleene_nonterminal.should_be_an_instance_of Class
  end
  
  specify "is named differently from another constructed kleene closure with different content" do
    @parser_class.kleene_closure(:Bar).should_not_equal(@kleene_nonterminal_sym)
  end
end