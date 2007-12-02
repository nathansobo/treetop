dir = File.dirname(__FILE__)

# Loading trusted version of Treetop to compile the compiler
trusted_treetop_path = Gem.source_index.find_name('treetop', ["1.1.3"]).last.full_gem_path
require File.join(trusted_treetop_path, 'lib', 'treetop')

# Relocating trusted version of Treetop to Trusted::Treetop
Trusted = Module.new
Trusted::Treetop = Treetop
Object.send(:remove_const, :Treetop)
Object.send(:remove_const, :TREETOP_ROOT)

# Requiring version of Treetop that is under test
require File.expand_path(File.join(dir, '..', 'lib', 'treetop'))
# Remove stale Metagrammar defined by the generated metagrammar.rb in system under test
Treetop::Compiler.send(:remove_const, :Metagrammar)

# Compile and evaluate freshly generated metagrammar source
METAGRAMMAR_PATH = File.join(TREETOP_ROOT, 'compiler', 'metagrammar.treetop')
compiled_metagrammar_source = Trusted::Treetop::Compiler::GrammarCompiler.new.ruby_source(METAGRAMMAR_PATH)
Object.class_eval(compiled_metagrammar_source)

$bootstrapped_compiler_being_tested = true