require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A terminal symbol" do
  before do
    test_expression "foo"    
  end
    
  it "correctly parses matching input prefixes at various indices" do    
    index = 0
    result = parse("foo")
    result.should be_an_instance_of(TerminalSyntaxNode)
    result.interval.should == (0...3)
    result.text_value.should == 'foo'

    index = 1
    result = parse("xfoo")
    result.should be_an_instance_of(TerminalSyntaxNode)
    result.interval.should == (1...4)
    result.text_value.should == 'foo'    
    
    index = 3
    result = parse("---foo")
    result.should be_an_instance_of(TerminalSyntaxNode)    
    result.interval.should == (3...6)
    result.text_value.should == 'foo'    
  end
  
  it "fails to parse nonmatching input at the index even if a match occurs later" do
    index = 0
    " foo".should fail_to_parse
  end
end

describe "A terminal symbol followed by a Ruby block with a method in it" do
  before do
    test_expression "'foo' { def a_method; end }"
  end
  
  it "returns a node that responds to that method" do
    result = parse('foo')
    result.should respond_to(:a_method)
  end
end

describe "A terminal symbol followed by a node class declaration" do
  before do
    ::Test = Module.new
    ::Test::NodeClass = Class.new(TerminalSyntaxNode)
    test_expression "'foo' <Test::NodeClass>"
  end
  
  after do
    Object.send(:const_remove, :Test)
  end
  
  it "returns a node with that class upon parsing successfully" do
    result = parse('foo')
    result.class.should == ::Test::NodeClass
  end
end