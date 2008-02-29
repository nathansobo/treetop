require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module SequenceSpec
  class Foo < Treetop::Runtime::SyntaxNode
  end

  describe "A sequence of labeled terminal symbols followed by a node class declaration and a block" do
    testing_expression 'foo:"foo" bar:"bar" baz:"baz" <SequenceSpec::Foo> { def a_method; end }'
    
    describe "the result upon successfully matching input" do
      attr_reader :result
      before do
        @result = parse('foobarbaz')
      end
      
      it "is successful" do
        result.should_not be_nil
      end
      
      it "is an instance of the declared node class" do
        result.should be_an_instance_of(Foo)
      end
      
      it "has element accessor methods based on the labels" do
        result.foo.text_value.should == 'foo'
        result.bar.text_value.should == 'bar'
        result.baz.text_value.should == 'baz'
      end
      
      it "has the method defined in the trailing block" do
        result.should respond_to(:a_method)
      end
      
      it "has the sequence elements as its #dependencies" do
        result.dependencies.should == result.elements
      end
    end

    it "successfully matches at a non-zero index" do
      parse('---foobarbaz', :index => 3) do |result|
        result.should_not be_nil
        result.should be_nonterminal
        (result.elements.map {|elt| elt.text_value}).join.should == 'foobarbaz'
      end
    end

    describe "upon failing to match input starting at index 3" do
      attr_reader :result
      
      before do
        @result = parse('---foobazbaz', :index => 3, :return_parse_failure => true)
      end
      
      describe "the result" do
        it "is not successful" do
          result.should be_an_instance_of(Runtime::ParseFailure)
        end
        
        it "depends on the failure of the first failing subexpression" do
          dependencies = result.dependencies
          dependencies.size.should == 1
          dependencies.first.index.should == 6
          dependencies.first.expected_string.should == 'bar'
        end
      end
      
      it "resets the parser index to where it was when parsing began" do
        parser.index.should == 3
      end
      
      it "records the parse failure of the first failing terminal in #terminal_failures" do
        terminal_failures = parser.terminal_failures
        terminal_failures.size.should == 1
        terminal_failures.first.index.should == 6
        terminal_failures.first.expected_string.should == 'bar'
      end
    end
  end

  describe "a sequence of non-terminals" do
    testing_grammar %{
      grammar TestGrammar
        rule sequence
          foo bar baz {
            def baz
              'override' + super.text_value
            end
          }
        end

        rule foo 'foo' end
        rule bar 'bar' end
        rule baz 'baz' end
      end
    }

    it "defines accessors for non-terminals automatically that can be overridden in the inline block" do
      parse('foobarbaz') do |result|
        result.foo.text_value.should == 'foo'
        result.bar.text_value.should == 'bar'
        result.baz.should == 'overridebaz'
      end
    end
  end

  describe "A sequence of two expressions, one of which generates a max_terminal_failure_index that exceeds the second" do
    testing_grammar %{
      grammar TestGrammar

        rule sequence
          first ' ' second
        end

        rule first
          'long terminal that fails' / 'foo'
        end

        rule second
          'bar' / 'baz'
        end
      end
    }

    it "generates a failure for the second element with an interval that spans across the area in which the source of the failure could have occurred" do
      result = parse("foo bogus", :return_parse_failure => true)
      result.should be_an_instance_of(Runtime::ParseFailure)
      node_cache = parser.send(:expirable_node_cache)
      failure = node_cache.get(:second, 4)
      failure.interval.should == (4...7)
    end
  end
  
  describe "Compiling a sequence containing various white-space errors" do
    it "should succeed on a valid sequence" do
      compiling_expression('foo:"foo" "bar" <SequenceSpec::Foo> { def a_method; end }').should_not raise_error
    end

    it "rejects space after a label" do
      compiling_expression('foo :"foo" "bar"').should raise_error(RuntimeError)
    end

    it "rejects space after label's colon" do
      compiling_expression('foo: "foo" "bar"').should raise_error(RuntimeError)
    end

    it "rejects missing space after a primary" do
      compiling_expression('foo:"foo""bar"').should raise_error(RuntimeError)
    end

    it "rejects missing space before node class declaration" do
      compiling_expression('foo:"foo" "bar"<SequenceSpec::Foo>').should raise_error(RuntimeError)
    end
    
    it "rejects missing space before inline module" do
      compiling_expression('foo:"foo" "bar" <SequenceSpec::Foo>{def a_method; end}').should raise_error(RuntimeError)
    end
  end
end
