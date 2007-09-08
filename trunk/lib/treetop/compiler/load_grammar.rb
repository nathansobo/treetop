class Object
  def load_grammar(path)
    adjusted_path = path =~ /\.treetop\Z/ ? path : path + '.treetop'
    compiler = Treetop::Compiler::GrammarCompiler.new
    Object.class_eval(compiler.ruby_source(adjusted_path))
  end
end