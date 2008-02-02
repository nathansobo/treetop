require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe "A grammar with a sequence of 3 nonterminals" do
  testing_grammar %{
    grammar TestGrammar
      rule foo
        the ' ' color ' ' dog
      end

      rule the
        'the'
      end

      rule color
        'aquamarine' / 'green' / 'red'
      end

      rule dog
        'dog'
      end
    end
  }

  attr_reader :parser

  before do
    @parser = self.class.const_get(:TestGrammarParser).new
  end

  it "recycles undisturbed nodes when the buffer expires" do
    input = "the green dog"

    result = parser.parse(input)
    the = result.the
    dog = result.dog

    input.gsub!('green', 'aquamarine')
    parser.expire(5..9, 5)

    new_result = parser.reparse
    new_result.should_not == result
    new_result.the.should == the
    new_result.dog.should == dog
  end

  it "correctly 'forgets' failures and recycles successfully parsed nodes preceding the failure" do
    pending "this is not yet fleshed out"
    input = "the green don"

    result = parser.parse(input)
    result.should be_nil

    node = parser.send(:expirable_node_cache)

    input.gsub!('green', 'aquamarine')
    parser.expire(5..9, 5)

    new_result = parser.reparse
    new_result.should_not == result
    new_result.the.should == the
    new_result.dog.should == dog
  end
end