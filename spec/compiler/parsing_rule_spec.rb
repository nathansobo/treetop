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
      node_cache = parser.send(:node_cache)

      node_cache[:bar].should_not have_key(0)
    
      parser._nt_bar
    
      cached_node = node_cache[:bar][0]        
      cached_node.should be_an_instance_of(Runtime::SyntaxNode)
      cached_node.text_value.should == 'baz'
    
      parser.send(:reset_index)
      parser._nt_bar.should equal(cached_node)
      parser.index.should == cached_node.interval.end
    end

    it "stores and retrieves failed results for that rule in its node cache" do
      parser = self.class.const_get(:FooParser).new
      parser.send(:prepare_to_parse, 'bogus')
      node_cache = parser.send(:node_cache)

      node_cache[:bar].should_not have_key(0)

      parser._nt_bar

      node_cache[:bar].should have_key(0)
      node_cache[:bar][0].should == nil

      parser.send(:reset_index)
      parser._nt_bar.should == nil
      parser.index.should == 0
    end
  end
end
