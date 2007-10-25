require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "A nonterminal symbol followed by a block", :extend => CompilerTestCase do
  testing_expression 'foo { def a_method; end }'
  
  parser_class_under_test.class_eval do
    def _nt_foo
      '_nt_foo called'
    end
  end
  
  it "compiles to a method call, extending its results with the anonymous module for the block" do
    result = parse('')
    result.should == '_nt_foo called'
    result.should respond_to(:a_method)
  end
end

# class NonterminalWithModuleDeclarationTest < CompilerTestCase
#   module TestModule
#     def a_method
#     end
#   end
#   
#   testing_expression 'foo <TestModule>'
#   
#   parser_class_under_test.class_eval do
#     def _nt_foo
#       '_nt_foo called'
#     end
#   end
#   
#   it "compiles to a method call, extending its results with the declared module" do
#     # result = parse('')
#     # result.should == '_nt_foo called'
#     # result.should respond_to(:a_method)
#   end
# end