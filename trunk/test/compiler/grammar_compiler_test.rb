require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GrammarCompilerTest < Screw::Unit::TestCase
  
  def setup
    @compiler = Compiler::GrammarCompiler.new
    @source_file_path = File.join(File.dirname(__FILE__), 'test_grammar.treetop')
    @target_file_path = File.join(File.dirname(__FILE__), 'test_grammar.rb')
    delete_target_file
  end
  
  def teardown
    delete_target_file
  end
  
  test "compilation of a single file" do
    assert !File.exists?(@target_file_path)
    @compiler.compile(@source_file_path)
    assert File.exists?(@target_file_path)
    require @target_file_path
    Test::Grammar.new.parse('foo').should be_success
  end
  
  def delete_target_file
    File.delete(@target_file_path) if File.exists?(@target_file_path)
  end
  
end

