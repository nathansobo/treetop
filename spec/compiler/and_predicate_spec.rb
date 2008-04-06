require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module AndPredicateSpec
  include Runtime

  describe "An &-predicated terminal symbol" do
    testing_expression '&"foo"'

    attr_reader :input, :result

    describe "the result of parsing input matching the predicated subexpression" do
      before do
        @input = 'foo'
        @result = parse(input, :consume_all_input => false)
      end

      it "is an epsilon node that includes its endpoint" do
        result.should be_epsilon
        result.interval.should == (0..0)
      end
      
      it "depends on the result of the predicated subexpression" do
        dependencies = result.dependencies
        dependencies.size.should == 1
        dependencies.first.text_value.should == 'foo'
      end
    end
    
    describe "the result of parsing input that does not match the predicated subexpression" do
      before do
        @result = parse('bar', :consume_all_input => false, :return_parse_failure => true)
      end

      it "is not successful" do
        result.should be_an_instance_of(Runtime::ParseFailure)
      end
      
      it "depends on the failure of the subexpression" do
        dependencies = result.dependencies
        dependencies.size.should == 1
        dependencies.first.expected_string.should == 'foo'
      end
    end
  end

  describe "A sequence of a terminal and an and another &-predicated terminal" do
    testing_expression '"foo" &"bar"'
    
    describe "the result of parsing input that matches both terminals" do
      attr_reader :input, :result
      
      before do
        @input = 'foobar'
        @result = parse(input, :consume_all_input => false)
      end
      
      it "is successful" do
        result.should_not be_nil
      end
      
      it "has the result of the first terminal and an epsilon node as its elements" do
        result.elements[0].text_value.should == 'foo'
        result.elements[1].should be_epsilon
      end
      
      it "is expired when a character is inserted between 'foo' and 'bar'" do
        result_cache.should have_result(:expression_under_test, 0)
        input.replace('fooxbar')
        expire(3..3, 1)
        result_cache.should_not have_result(:expression_under_test, 0)
      end
    end

    describe "upon parsing input that matches the first terminal but not the second" do
      attr_reader :input, :result
      before do
        @input = 'foolish'
        @result = parse(input)
      end

      it "results is a failure" do
        result.should be_nil
      end

      it "records a terminal failure at index 3" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        terminal_failures.first.index.should == 3
        terminal_failures.first.expected_string.should == 'bar'
      end

      it "will subsequently expire the result if input is inserted at index 3" do
        result_cache.should have_result(:expression_under_test, 0)

        input.replace('foobarlish')
        result_cache.expire(3..3, 3)

        result_cache.should_not have_result(:expression_under_test, 0)
        parser.consume_all_input = false
        reparse.should_not be_nil
      end
    end

    describe "the result of parsing input that matches only the first terminal" do
      attr_reader :input, :result
      
      before do
        @input = 'foo'
        @result = parse(input)
      end

      it "the result is a failure" do
        result.should be_nil
      end

      it "a terminal failure is recorded at index 3" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        terminal_failures.first.index.should == 3
        terminal_failures.first.expected_string.should == 'bar'
      end

      it "will subsequently expire the result if input is inserted at index 3" do
        result_cache.should have_result(:expression_under_test, 0)

        input.replace('foobar')
        result_cache.expire(3..3, 3)

        result_cache.should_not have_result(:expression_under_test, 0)
      end
    end
  end

  describe "An expression for a character not followed by a space" do
    testing_expression "'a' &(!' ' .)"

    attr_reader :input, :result

    describe "after parsing that character followed by a space" do
      before do
        @input = "a "
        @result = parse(input, :consume_all_input => false)
      end

      it "results in a failure" do
        result.should be_nil
      end

      it "expires the failure when a character is subsequently inserted between the character and the space" do
        result_cache.should have_result(:expression_under_test, 0)

        input.replace('ab ')
        parser.expire(1..1, 1)

        result_cache.should_not have_result(:expression_under_test, 0)
        reparse.should_not be_nil
      end
    end
  end
end