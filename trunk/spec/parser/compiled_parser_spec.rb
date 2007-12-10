require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module CompiledParserSpec
  describe Runtime::CompiledParser, "for a grammar with two rules" do
    attr_reader :parser
    
    testing_grammar %{
      grammar TwoRules
        rule a
          'a'
        end
        
        rule b
          'b'
        end
      end
    }
    
    before do
      @parser = parser_class_under_test.new
    end
  
    it "allows its root to be specified" do
      parser.parse('a').should_not be_nil
      parser.parse('b').should be_nil
      
      parser.root = :b
      parser.parse('b').should_not be_nil
      parser.parse('a').should be_nil
    end
    
    it "allows the requirement that all input be consumed to be disabled" do
      parser.parse('ab').should be_nil
      parser.consume_all_input = false
      result = parser.parse('ab')
      result.should_not be_nil
      result.interval.should == (0...1)
    end
    
    it "allows input to be parsed at a given index" do
      parser.parse('ba').should be_nil
      parser.parse('ba', :index => 1).should_not be_nil
    end
  end
  
  describe Runtime::CompiledParser,  "#terminal_failures" do
    testing_grammar %{
      grammar SequenceOfTerminals
        rule foo
          'a' 'b' 'c'
        end
      end
    }
    
    attr_reader:parser
    
    before do
      @parser = parser_class_under_test.new
    end
    
    it "is reset between parses" do
      parser.parse('ac')
      terminal_failures = parser.terminal_failures
      terminal_failures.size.should == 1
      failure = terminal_failures.first
      failure.index.should == 1
      failure.expected_string.should == 'b'
      
      parser.parse('b')
      terminal_failures = parser.terminal_failures
      terminal_failures.size.should == 1
      failure = terminal_failures.first
      failure.index.should == 0
      failure.expected_string.should == 'a'
    end
  end
end