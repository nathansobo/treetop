dir = File.dirname(__FILE__)

# Loading trusted version of Treetop to compile the compiler
trusted_treetop_path = Gem.source_index.find_name('treetop').last.full_gem_path
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
Treetop::Compiler.send(:remove_const, :MetagrammarParser)

# Compile and evaluate freshly generated metagrammar source
METAGRAMMAR_PATH = File.join(TREETOP_ROOT, 'compiler', 'metagrammar.treetop')
compiled_metagrammar_source = Trusted::Treetop::Compiler::GrammarCompiler.new.ruby_source(METAGRAMMAR_PATH)
Object.class_eval(compiled_metagrammar_source)

# The compiler under test was compiled with the trusted grammar and therefore depends on its runtime
# But the runtime in the global namespace is the new runtime. We therefore inject the tursted runtime
# into the compiler so its parser functions correctly
Treetop::Compiler::Metagrammar.module_eval do
  include Trusted::Treetop::Runtime
end

Treetop::Compiler.send(:remove_const, :MetagrammarParser)
class Treetop::Compiler::MetagrammarParser < Trusted::Treetop::Runtime::CompiledParser
  include Treetop::Compiler::Metagrammar
end

$bootstrapped_compiler_being_tested = true