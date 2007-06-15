dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The keyword rule's parsing expression" do
  before do
    @keyword_expression = Metagrammar.get_parsing_expression(Metagrammar.nonterminal_symbol(:keyword))
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
  end
end