dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "The keyword rule's parsing expression" do
  before do
    @protometagrammar = Protometagrammar.new
    @keyword_expression = @protometagrammar.get_parsing_expression(@protometagrammar.nonterminal_symbol(:keyword))
  end
  
  it "parses 'rule' followed by a space" do
    @keyword_expression.parse_at('rule ', 0, parser_with_empty_cache_mock).should be_success
  end
  
  it "parses 'end' followed by a space" do
    @keyword_expression.parse_at('end ', 0, parser_with_empty_cache_mock).should be_success
  end

  it "parses 'end' followed by a  the end of input" do
    @keyword_expression.parse_at('end', 0, parser_with_empty_cache_mock).should be_success
  end

  it "does not parse keywords followed by non-whitespace character" do
    @keyword_expression.parse_at('rulez', 0, parser_with_empty_cache_mock).should be_failure
    @keyword_expression.parse_at('ender', 0, parser_with_empty_cache_mock).should be_failure
  end
end