dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the treetop_file rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:treetop_file)
    @parser = parser_for_metagrammar
  end
  
  after do
    reset_metagrammar_root
  end
  
  it "allows a grammar to be defined within an arbitrary module" do
    
    input = %{
      module Foo
        grammar Bar
        end
      end
    }
    
    result = @parser.parse(input)
    result.should be_success
    
    eval(result.to_ruby)
    
    Foo::Bar.should be_an_instance_of(Grammar)
    
    teardown_global_constant(:Foo)
  end
  
  it "allows arbitrary ruby to be executed before and after a grammar declaration" do
    input = %{
      @x = 'foo'
      grammar Bar
      end
      @y = 'bar'
    }
    
    result = @parser.parse(input)
    result.should be_success
    
    eval(result.to_ruby)
    
    @x.should == 'foo'
    @y.should == 'bar'
    
    Bar.should be_an_instance_of(Grammar)
    teardown_global_constant(:Bar)
  end
end
