require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

include DefinesParsers

context "An parser with a simple arithmetic grammar" do
  setup do 
    @parser_class = create_parser_class(:Arithmetic)
                                  
    @parser_class.add_nonterminal :Additive
    @parser_class::Additive.add_alternative(Alternative.new([:Multitive, '+', :Additive]))
    @parser_class::Additive.add_alternative(Alternative.new([:Multitive]))

    @parser_class.add_nonterminal :Multitive
    @parser_class::Multitive.add_alternative(Alternative.new([:Primary, '*', :Multitive]))
    @parser_class::Multitive.add_alternative(Alternative.new([:Primary]))

    @parser_class.add_nonterminal :Primary
    @parser_class::Primary.add_alternative(Alternative.new(['(', :Additive, ')']))
    @parser_class::Primary.add_alternative(Alternative.new([:Decimal]))

    @parser_class.add_nonterminal :Decimal
    @parser_class::Decimal.add_alternative(Alternative.new([:Digit, :Decimal]))
    @parser_class::Decimal.add_alternative(Alternative.new([:Digit]))

    @parser_class.add_nonterminal :Digit
    (0..9).each {|digit| @parser_class::Digit.add_alternative(Alternative.new([digit.to_s])) }
    
    @parser_instance = @parser_class.new
  end
  
  specify "knows the constant name to which it corresponds" do
    @parser_class.name.should_equal :Arithmetic
  end
  
  specify "parses basic multiplication" do
     @parser_instance.parse("3*5").should_be_an_instance_of @parser_class.root
  end
  
  specify "parser a complex expression with nested parentheses" do
     @parser_instance.parse("3+(45*(4+5)+8)*4").should_be_an_instance_of @parser_class.root
  end
  
  specify "fails to parse a malformed expression" do
    @parser_instance.parse("3+(45*(4+5)++8)*4").should_be_nil
    @parser_instance.parse("3+(45*(4+5)*").should_be_nil
  end
  
  specify "fails if parse does not consume entire buffer" do
    @parser_instance.parse("3+(45*(4+5)++8)*4   ").should_be_nil
  end
  
end

context "The kleene closure of a digit nonterminal" do
  setup do
    @parser_class = create_parser_class(:Arithmetic)
    
    @parser_class.add_nonterminal(:Digit)
    (0..9).each {|digit| @parser_class::Digit.add_alternative(Alternative.new([digit.to_s])) }
      
    kleene_nonterminal_sym = @parser_class.kleene_closure(:Digit)
    @kleene_nonterminal = @parser_class.get_nonterminal(kleene_nonterminal_sym)
    
    @parser_instance = @parser_class.new
  end
  
  specify "parses no digits successfully" do
    @kleene_nonterminal.parse_at(0, "", @parser_instance).should_not_be_failure
  end
  
  specify "parses one digit successfully" do
    @kleene_nonterminal.parse_at(0, "0", @parser_instance).should_not_be_failure
  end
  
  specify "parses multiple digits successfully" do
    @kleene_nonterminal.parse_at(0, "012", @parser_instance).should_not_be_failure
  end

  specify "flattens its linked list of children into an array" do
    parse_value_grandchildren = @kleene_nonterminal.parse_at(0, "012", @parser_instance).
                                                    value.
                                                    children.
                                                    collect { |child| child.children[0] }
    parse_value_grandchildren.should_eql ['0', '1', '2']
  end

end
