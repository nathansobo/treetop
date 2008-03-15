require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module OptionalSpec
  describe "An optional terminal symbol" do
    attr_reader :result
    
    testing_expression '"foo"?'
  
    describe "the result of parsing matching input" do
      before do
        @result = parse('foo')
      end
      
      it "is the result of the optional subexpression" do
        result.should be_terminal
        result.text_value.should == 'foo'
      end
    end
  
    describe "upon parsing epsilon" do
      attr_reader :input

      before do
        @input = ''
        @result = parse(input)
      end
      
      describe "the result" do
        it "is an epsilon node" do
          result.should be_epsilon
        end
      
        it "is dependent on the failure of the optional subexpression" do
          dependencies = result.dependencies
          dependencies.size.should == 1
          dependencies.first.expected_string.should == 'foo'
        end

        it "includes its endpoint, which is the site of the failure to parse the optional expression" do
          result.interval.should == (0..0)
        end

        it "is expired when something is inserted at the site at which the optional expression was originally not found" do
          node_cache.should have_result(:expression_under_test, 0)

          input.replace('foo')
          node_cache.expire(0..0, 3)

          node_cache.should_not have_result(:expression_under_test, 0)
        end
      end
      
      it "records the failure in #terminal_failures" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures.first
        failure.index.should == 0
        failure.expected_string.should == 'foo'
      end
    end
    
    describe "upon parsing non-matching input" do
      before do
        @result = parse('baz', :consume_all_input => false)
      end
      
      describe "the result" do
        it "is an epsilon node" do
          result.should be_epsilon
        end
      
        it "is dependent on the failure of the optional subexpression" do
          dependencies = result.dependencies
          dependencies.size.should == 1
          dependencies.first.expected_string.should == 'foo'
        end
      end
      
      it "records the failure in #terminal_failures" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures.first
        failure.index.should == 0
        failure.expected_string.should == 'foo'
      end
    end
  end
end
