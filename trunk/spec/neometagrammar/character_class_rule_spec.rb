dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the character_class rule's successful parsing of '[A-C123\\]]'" do
  include MetagrammarSpecContextHelper
  
  before(:all) do
    with_metagrammar(:character_class) do |parser|
      @node = parser.parse('[A-C123\]]')
    end
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to a character class that will parse any character in that class" do
    @node.to_ruby.should == 'CharacterClass.new(\'A-C123\]\')'
    value = eval(@node.to_ruby)
    
    value.should be_an_instance_of(CharacterClass)

    parser = parser_with_empty_cache_mock
    value.parse_at('A', 0, parser).should be_success
    value.parse_at('B', 0, parser).should be_success
    value.parse_at('C', 0, parser).should be_success
    value.parse_at('1', 0, parser).should be_success
    value.parse_at('2', 0, parser).should be_success
    value.parse_at('3', 0, parser).should be_success
    value.parse_at(']', 0, parser).should be_success    
  end
end