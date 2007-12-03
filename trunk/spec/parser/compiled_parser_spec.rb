require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module CompiledParserSpec
  describe "a compiled parser for a grammar with two nonterminals" do
    attr_reader :parser
    
    grammar_syntax_tree = Compiler::MetagrammarParser.new.parse(%{
      module CompiledParserSpec
        grammar Test
          rule a
            'a'
          end
          
          rule b
            'b'
          end
        end
      end
    })
    raise "Grammar under test could not be parsed" unless grammar_syntax_tree.success?
    Object.class_eval(grammar_syntax_tree.compile)
    
    before do
      @parser = TestParser.new
    end
    
    it "allows its root to be specified" do
      parser.parse('a').should be_success
      parser.parse('b').should_not be_success
      
      parser.root = :b
      parser.parse('b').should be_success
      parser.parse('a').should_not be_success
    end
    
    it "allows the requirement that all input be consumed to be disabled" do
      parser.parse('ab').should_not be_success
      parser.consume_all_input = false
      result = parser.parse('ab')
      result.should be_success
      result.interval.should == (0...1)
    end
    
    it "allows input to be parsed at a given index" do
      parser.parse('ba').should_not be_success
      parser.parse('ba', :index => 1).should be_success
    end
  end
end