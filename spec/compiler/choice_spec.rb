require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ChoiceSpec
  describe "A choice between terminal symbols" do
    testing_expression '"foo" { def foo_method; end } / "bar" { def bar_method; end } / "baz" { def baz_method; end }'

    it "successfully parses input matching any of the alternatives, returning a node that responds to methods defined in its respective inline module" do
      result = parse('foo')
      result.should_not be_nil
      result.should respond_to(:foo_method)
    
      result = parse('bar')
      result.should_not be_nil
      result.should respond_to(:bar_method)
    
      result = parse('baz')
      result.should_not be_nil
      result.should respond_to(:baz_method)
    end
    
    
    it "upon parsing a string matching the first alternative, returns a Propagation with the result of the first alternative as its result" do
      result = parse('foo', :return_propagations => true)
      result.should be_an_instance_of(Runtime::Propagation)
      result.element.should be_terminal
      result.element.text_value.should == 'foo'
    end
    
    describe "upon parsing a string matching the second alternative" do
      attr_reader :result

      before do
        @result = parse('bar', :return_propagations => true)
      end

      describe "the result" do
        it "is an instance Propagation" do
          result.should be_an_instance_of(Runtime::Propagation)
        end

        it "has the result of the second alternative as its #element" do
          result.element.should be_terminal
          result.element.text_value.should == 'bar'
        end

        it "has the successful result of the second alternative and the failing result of the first alternative as its dependencies" do
          dependencies = result.dependencies
          dependencies.size.should == 2
          dependencies[0].should ==  result.element          
          dependencies[1].should be_an_instance_of(Runtime::TerminalParseFailure)
          dependencies[1].expected_string.should == 'foo'
        end
      end
      
      it "records the failure of the first terminal" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        failure = terminal_failures[0]
        failure.expected_string.should == 'foo'
        failure.index.should == 0
      end
    end

    describe "upon parsing a string matching the third alternative" do
      attr_reader :result

      before do
        @result = parse("baz", :return_propagations => true)
      end

      describe "the result" do
        it "is an instance Propagation" do
          result.should be_an_instance_of(Runtime::Propagation)
        end

        it "has the result of the third alternative as its #element" do
          result.element.should be_terminal
          result.element.text_value.should == 'baz'
        end
        
        it "has  the successful result of the third alternative  and the failing results of the first and second alternatives as its dependencies" do
          dependencies = result.dependencies
          dependencies.size.should == 3
          dependencies[0].should ==  result.element
          dependencies[1].should be_an_instance_of(Runtime::TerminalParseFailure)
          dependencies[1].expected_string.should == 'foo'
          dependencies[2].should be_an_instance_of(Runtime::TerminalParseFailure)
          dependencies[2].expected_string.should == 'bar'          
        end
      end
      
      it "records the failure of the first terminal and second terminals" do
        terminal_failures = parser.terminal_failures

        terminal_failures.size.should == 2

        failure_1 = terminal_failures[0]
        failure_1.expected_string == 'foo'
        failure_1.index.should == 0

        failure_2 = terminal_failures[1]
        failure_2.expected_string == 'bar'
        failure_2.index.should == 0        
      end
    end

    describe "the result of parsing non-matching input" do
      attr_reader :result
      before do
        @result = parse('cat', :return_parse_failure => true)
      end

      it "is a ParseFailure that depends on the failure of all 3 alternatives" do
        result.should be_an_instance_of(Runtime::ParseFailure)
        dependencies = result.dependencies

        dependencies.size.should == 3
        dependencies[0].should be_an_instance_of(Runtime::TerminalParseFailure)
        dependencies[0].expected_string.should == 'foo'
        dependencies[1].should be_an_instance_of(Runtime::TerminalParseFailure)
        dependencies[1].expected_string.should == 'bar'
        dependencies[2].should be_an_instance_of(Runtime::TerminalParseFailure)
        dependencies[2].expected_string.should == 'baz'          
      end
    end
  end

  describe "A choice between sequences" do
    testing_expression "'foo' 'bar' 'baz'\n/\n'bing' 'bang' 'boom'"

    it "successfully parses input matching any of the alternatives" do
      parse('foobarbaz').should_not be_nil
      parse('bingbangboom').should_not be_nil 
    end
  end

  describe "A choice between terminals followed by a block" do  
    testing_expression "('a'/ 'b' / 'c') { def a_method; end }"

    it "extends a match of any of its subexpressions with a module created from the block" do
      ['a', 'b', 'c'].each do |letter|
        parse(letter).element.should respond_to(:a_method)
      end
    end
  end

  module TestModule
    def a_method
    end
  end

  describe "a choice followed by a declared module" do  
    testing_expression "('a'/ 'b' / 'c') <ChoiceSpec::TestModule>"

    it "extends a match of any of its subexpressions with a module created from the block" do
      ['a', 'b', 'c'].each do |letter|
        parse(letter).element.should respond_to(:a_method)
      end
    end
  end
end