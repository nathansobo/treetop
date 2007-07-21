require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A terminal symbol" do
  testing_expression "'foo'"

  it "correctly parses matching input prefixes at various indices" do
    parse "foo", :at_index => 0 do |result|
      result.should be_an_instance_of(TerminalSyntaxNode)
      result.interval.should == (0...3)
      result.text_value.should == 'foo'
    end
  end
  # 
  #   parse "xfoo", :at_index => 1 do |result|
  #     result.should be_an_instance_of(TerminalSyntaxNode)
  #     result.interval.should == (1...4)
  #     result.text_value.should == 'foo'
  #   end
  #   
  #   parse "---foo", :at_index => 3 do |result|
  #     result.should be_an_instance_of(TerminalSyntaxNode)
  #     result.interval.should == (3...6)
  #     result.text_value.should == 'foo'
  #   end
  # end
  # 
  # it "fails to parse nonmatching input at the index even if a match occurs later" do
  #   parse(" foo", :at_index =>  0).should be_failure
  # end
end

# describe "A terminal symbol followed by a Ruby block with a method in it" do
# 
#   test_expression "'foo' { def a_method; end }"
# 
#   
#   it "returns a node that responds to that method" do
#     result = parse('foo')
#     result.should respond_to(:a_method)
#   end
# end
# 
# describe "A terminal symbol followed by a node class declaration" do
#   before do
#     ::Test = Module.new
#     ::Test::NodeClass = Class.new(TerminalSyntaxNode)
#     test_expression "'foo' <Test::NodeClass>"
#   end
#   
#   after do
#     Object.send(:const_remove, :Test)
#   end
#   
#   it "returns a node with that class upon parsing successfully" do
#     result = parse('foo')
#     result.class.should == ::Test::NodeClass
#   end
# end