require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NonterminalSymbolSpec
  include Runtime

  describe "A nonterminal symbol followed by a block" do
    testing_expression 'foo { def a_method; end }'

    parser_class_under_test.class_eval do
      attr_reader :method_called

      define_method :_nt_foo do
        @method_called = true
        SyntaxNode.new("test input", 0..4)
      end
    end
  
    it "compiles to a method call, extending its results with the anonymous module for the block" do
      result = parse('')
      parser.method_called.should be_true
      result.should respond_to(:a_method)
    end
  end

  module TestModule
    def a_method
    end
  end

  describe "a non-terminal followed by a module declaration" do
    testing_expression 'foo <NonterminalSymbolSpec::TestModule>'
  
    parser_class_under_test.class_eval do
      attr_reader :method_called

      def _nt_foo
        @method_called = true
        SyntaxNode.new("test input", 0..4)
      end
    end
  
    it "compiles to a method call, extending its results with the anonymous module for the block" do
      result = parse('')
      parser.method_called.should be_true
      result.should respond_to(:a_method)
    end
  end
end