require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ParsingRuleTest < CompilerTestCase

  testing_grammar_2 %{
    grammar Foo
      rule bar
        "baz"
      end
    end
  }

  test "node cache storage and retrieval" do
    parser = Foo.new
    parser.send(:prepare_to_parse, 'baz')
    node_cache = parser.send(:node_cache)
    
    node_cache[:bar][0].should be_nil
    
    parser._nt_bar
    
    cached_node = node_cache[:bar][0]        
    cached_node.should be_an_instance_of(Parser::SyntaxNode)
    cached_node.text_value.should == 'baz'
    
    parser.instance_eval { @index = 0 }
    parser._nt_bar.should equal(cached_node)
    parser.index.should == cached_node.interval.end
  end
end