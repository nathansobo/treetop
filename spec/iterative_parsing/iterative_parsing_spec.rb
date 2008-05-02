require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module IterativeParsingSpec
  include Runtime

  describe "A parser for a grammar with a sequence of 3 nonterminals" do
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
          'dog' / 'cat'
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
      color = result.color
      dog = result.dog

      input.gsub!('green', 'aquamarine')
      parser.expire(5..9, 5)
      result_cache.results.should include(the)
      result_cache.results.should_not include(color)
      result_cache.results.should include(dog)

      new_result = parser.reparse
      new_result.should_not == result
      new_result.the.should == the
      new_result.dog.should == dog
    end

    it "expires corrected failures and recycles successfully parsed nodes preceding the failure" do

      input = "the green dot"

      result = parser.parse(input)
      result.should be_nil

      parser.max_terminal_failure_last_index.should == 13

      the = result_cache.get_result(:the, 0)
      the.text_value.should == "the"

      green = result_cache.get_result(:color, 4)
      green.element.text_value.should == "green"

      failure = result_cache.get_result(:dog, 10)
      failure.should be_an_instance_of(ParseFailure)
      failure.interval.should == (10..10)
      
      input[12] = 'g'

      parser.expire(12..13, 0)
      result_cache.should_not have_result(:dog, 10)
      result_cache.should_not have_result(:color, 4)
      result_cache.should_not have_result(:foo, 0)

      new_result = parser.reparse

      new_result.should_not be_nil
      new_result.the.should == the
      new_result.color.should_not == green
    end
  end

  describe "A parser for a grammar with a parsing rule ending in a positive lookahead predicate" do
    testing_grammar %{
      grammar TestGrammar2

        rule a
          b 'baz'
        end

        rule b
          'foo' c
        end

        rule c
          'bar' &'baz'
        end
      end
    }

    it "expires portions of the tree that depend on the result of the predicated expression even if their intervals don't contain it" do
      result = parse('foobarbaz')
      result.should_not be_nil

      result_cache = parser.send(:expirable_result_cache)
      result_cache.should have_result(:a, 0)
      result_cache.should have_result(:b, 0)
      result_cache.should have_result(:c, 3)

      result_cache.expire(7..8, 0)

      result_cache.should_not have_result(:a, 0)
      result_cache.should_not have_result(:b, 0)
      result_cache.should_not have_result(:c, 3)
    end
  end

  describe "A parser for a simplified addition grammar" do
    testing_grammar %{
      grammar Addition
        rule addition
          number '+' addition / number
        end

        rule number
          [0-9]
        end
      end
    }

    it "expires the results of choices that depend on failures that are invalidated as the user types" do
      input = '1'
      parse(input).should_not be_nil
      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:number, 0)

      input.replace('1+')
      expire(1..1, 1)

      result_cache.should_not have_result(:addition, 0)
      result_cache.should have_result(:number, 0)

      reparse.should be_nil

      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:number, 0)

      input.replace('1+1')
      expire(2..2, 1)

      result_cache.should_not have_result(:addition, 0)
      result_cache.should have_result(:number, 0)

      reparse.should_not be_nil

      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:number, 0)
      result_cache.should have_result(:addition, 2)
      result_cache.should have_result(:number, 2)
    end
  end

  describe "A parser for a simplified addition grammar with parenthesized expressions" do
    testing_grammar %{
      grammar Addition
        rule addition
          primary '+' addition / primary
        end

        rule primary
          '(' addition ')' / number
        end

        rule number
          [0-9]
        end
      end
    }

    it "expires the stale failure of addition as successive characters are added to the buffer" do
      input = '('
      parse(input, :return_parse_failure => true, :return_propagations => true)
      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:primary, 0)
      result_cache.should have_result(:number, 0)

      expire(1..1, 1)
      result_cache.should_not have_result(:addition, 0)
      result_cache.should_not have_result(:primary, 0)
      result_cache.should have_result(:number, 0)

      input.replace('(1')
      reparse
      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:addition, 1)
      result_cache.should have_result(:primary, 0)
      result_cache.should have_result(:primary, 1)
      result_cache.should have_result(:number, 0)
      result_cache.should have_result(:number, 1)
      
      expire(2..2, 1)
      result_cache.should_not have_result(:addition, 0)
      result_cache.should_not have_result(:addition, 1)
      result_cache.should_not have_result(:primary, 0)
      result_cache.should have_result(:primary, 1)
      result_cache.should have_result(:number, 0)
      result_cache.should have_result(:number, 1)

      input.replace('(1+')
      reparse
      result_cache.should have_result(:addition, 0)
      result_cache.should have_result(:addition, 1)
      result_cache.should have_result(:primary, 0)
      result_cache.should have_result(:primary, 1)
      result_cache.should have_result(:number, 0)
      result_cache.should have_result(:number, 1)

      expire(3..3, 1)

      result_cache.should_not have_result(:addition, 0)
      result_cache.should_not have_result(:addition, 1)
      result_cache.should_not have_result(:addition, 2)
      result_cache.should_not have_result(:primary, 0)
      result_cache.should have_result(:primary, 1) # is this true?
      result_cache.should_not have_result(:primary, 2)
      result_cache.should have_result(:number, 0)
      result_cache.should have_result(:number, 1)
      result_cache.should_not have_result(:number, 2)

      input.replace('(1+2')
      reparse

      expire(4..4, 1)
      input.replace('(1+2)')
      reparse.should_not be_nil
    end
  end

  describe "A parser for the full The full arithmetic grammar" do
    include PrintDependencies

    attr_reader :parser_class_under_test
    before do
      dir = File.dirname(__FILE__)
      Treetop.load "#{dir}/arithmetic"
      @parser_class_under_test = ArithmeticParser
    end

    it "successfully parses a problematic series of inputs without stack overflow" do
      input = '(1)'
      parse(input).should_not be_nil

      input.replace('((1)')
      expire(0..0, 1)
      parser.reparse.should be_nil

      input.replace('((1))')
      expire(4..4, 1)
      parser.reparse.should_not be_nil
    end
    
    it "successfully expires repetitions when the site of the repetition-terminating failure is disturbed" do
      input = '(1)'
      parse(input).should_not be_nil

      input.replace('(12)')
      expire(2..2, 1)

      result_cache.should_not have_result(:number, 1)
      parser.reparse.should_not be_nil

      input.replace('(122)')
      expire(3..3, 1)
      result_cache.should_not have_result(:number, 1)
      parser.reparse.should_not be_nil
    end
  end
end