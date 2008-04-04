require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ParsingRuleSpec
  describe "a grammar with one parsing rule" do

    testing_grammar %{
      grammar Foo
        rule bar
          "baz"
        end
      end
    }

    it "stores and retrieves successful results for that rule in its node cache, correctly updating the index upon retrieval" do
      parser = self.class.const_get(:FooParser).new
      parser.send(:prepare_to_parse, 'baz')
      result_cache = parser.send(:expirable_result_cache)

      result_cache.should_not have_result(:bar, 0)
    
      parser._nt_bar
    
      cached_node = result_cache.get_result(:bar, 0)
      cached_node.should be_an_instance_of(Runtime::SyntaxNode)
      cached_node.text_value.should == 'baz'
    
      parser.send(:reset_index)
      parser._nt_bar.should equal(cached_node)
      parser.index.should == cached_node.interval.end
    end

    it "stores and retrieves failed results for that rule in its node cache" do
      parser = self.class.const_get(:FooParser).new
      parser.send(:prepare_to_parse, 'bogus')
      result_cache = parser.send(:expirable_result_cache)

      result_cache.should_not have_result(:bar, 0)

      parser._nt_bar

      result_cache.should have_result(:bar, 0)
      result = result_cache.get_result(:bar, 0)
      result.should be_an_instance_of(Runtime::TerminalParseFailure)

      parser.send(:reset_index)
      parser._nt_bar.should == result
      parser.index.should == 0
    end
  end
end
