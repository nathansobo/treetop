require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "An expression for braces surrounding zero or more letters followed by semicolons", :extend => CompilerTestCase do
  testing_expression "'{' ([a-z] ';')* '}'"
  
  it "parses matching input successfully" do
    parse('{a;b;c;}').should be_success
  end
  
  it "fails to parse input with an expression that is missing a semicolon, reporting the correct nested failure" do
    parse('{a;b;c}') do |result|
      result.should be_failure
      
      result.nested_failures.size.should == 1      
      nested_failure = result.nested_failures[0]
      nested_failure.index.should == 6
      nested_failure.expected_string.should == ';'
    end
  end
end