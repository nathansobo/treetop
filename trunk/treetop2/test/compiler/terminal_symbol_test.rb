require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "A terminal symbol", :extend => CompilerTestCase do
  testing_expression "'foo'"

  it "correctly parses matching input prefixes at various indices" do
    parse "foo", :at_index => 0 do |result|
      result.should be_an_instance_of(Parser::TerminalSyntaxNode)
      result.interval.should == (0...3)
      result.text_value.should == 'foo'
    end

    parse "xfoo", :at_index => 1 do |result|
      result.should be_an_instance_of(Parser::TerminalSyntaxNode)
      result.interval.should == (1...4)
      result.text_value.should == 'foo'
    end
    
    parse "---foo", :at_index => 3 do |result|
      result.should be_an_instance_of(Parser::TerminalSyntaxNode)
      result.interval.should == (3...6)
      result.text_value.should == 'foo'
    end
  end

  it "fails to parse nonmatching input at the index even if a match occurs later" do
    parse(" foo", :at_index =>  0).should be_failure
  end
end