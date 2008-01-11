require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Compiler::GrammarCompiler do
  attr_reader :compiler, :source_path_with_treetop_extension, :source_path_with_tt_extension, :target_path, :alternate_target_path
  before do
    @compiler = Compiler::GrammarCompiler.new

    dir = File.dirname(__FILE__)
    @source_path_with_treetop_extension = "#{dir}/test_grammar.treetop"
    @source_path_with_tt_extension = "#{dir}/test_grammar.tt"
    @target_path = "#{dir}/test_grammar.rb"
    @alternate_target_path = "#{dir}/test_grammar_alt.rb"
    delete_target_files
  end

  after do
    delete_target_files
    Object.class_eval do
      remove_const(:Test) if const_defined?(:Test)
    end
  end

  specify "compilation of a single file to a default file name" do
    File.exists?(target_path).should be_false
    compiler.compile(source_path_with_treetop_extension)
    File.exists?(target_path).should be_true
    require target_path
    Test::GrammarParser.new.parse('foo').should_not be_nil
  end

  specify "compilation of a single file to an explicit file name" do
    File.exists?(alternate_target_path).should be_false
    compiler.compile(source_path_with_treetop_extension, alternate_target_path)
    File.exists?(alternate_target_path).should be_true
    require alternate_target_path
    Test::GrammarParser.new.parse('foo').should_not be_nil
  end

  specify "compilation of a single file without writing it to an output file" do
    compiler.ruby_source(source_path_with_treetop_extension).should_not be_nil
  end

  specify "Treetop.load compiles and evaluates a source grammar with a .treetop extension" do    
    Treetop.load source_path_with_treetop_extension
    Test::GrammarParser.new.parse('foo').should_not be_nil
  end
  
  specify "Treetop.load compiles and evaluates a source grammar with a .tt extension" do
    path_without_extension = source_path_with_tt_extension
    Treetop.load path_without_extension
    Test::GrammarParser.new.parse('foo').should_not be_nil
  end


  specify "Treetop.load compiles and evaluates source grammar with no extension" do
    path_without_extension = source_path_with_treetop_extension.gsub(/\.treetop\Z/, '')
    Treetop.load path_without_extension
    Test::GrammarParser.new.parse('foo').should_not be_nil
  end


  def delete_target_files
    File.delete(target_path) if File.exists?(target_path)
    File.delete(alternate_target_path) if File.exists?(alternate_target_path)
  end
end

