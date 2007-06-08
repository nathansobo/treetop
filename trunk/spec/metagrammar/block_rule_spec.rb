dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the block rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :block
  end

  it "parses an empty block" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('{}')
      result.should be_success
      result.value.should == ""
    end
  end
  
  it "parses an otherwise empty block with space between the braces" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('{   }')
      result.should be_success
      result.value.should == "   "
    end
  end

  it "parses a block with characters other than curly braces between its braces" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      text = "some_text"
      result = parser.parse("{#{text}}")
      result.should be_success
      result.value.should == text
    end
  end

  it "parses a block with Ruby code that uses blocks in it" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      ruby_code = "[1, 2, 3].map {|x| x + 1}"
      block = "{#{ruby_code}}"
      result = parser.parse(block)
      result.should be_success
      result.value.should == ruby_code
    end
  end
  
  it "parses a block with newlines in it" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("{\ndef a_method\n\nend\n}")
      result.should be_success
    end
  end
end

describe "In the Metagrammar only, the node returned by the block rule's successful parsing of a Ruby block with newlines between its contents and its enclosing braces" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:block) do |parser|
      @block_contents = "\ndef a_method\n\nend\n"
      @node = parser.parse("{#{@block_contents}}")
    end
  end
  
  it "has a Ruby source representation" do
    @node.to_ruby.should == "do#{@block_contents}end"
  end
end

describe "In the Metagrammar only, the node returned by the block rule's successful parsing of a Ruby block with no whitespace between its contents and its enclosing braces" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:block) do |parser|
      @block_contents = "def a_method\n\nend"
      @node = parser.parse("{#{@block_contents}}")
    end
  end
  
  it "has a Ruby source representation with newlines inserted between the do and end to ensure syntactic correctness" do
    @node.to_ruby.should == "do\n#{@block_contents}\nend"
  end
end