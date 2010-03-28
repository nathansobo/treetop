dir = File.dirname(__FILE__)
require 'rubygems'
require 'rake'
$LOAD_PATH.unshift(File.join(dir, 'vendor', 'rspec', 'lib'))
require 'spec/rake/spectask'

require 'rake/gempackagetask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.pattern = 'spec/**/*spec.rb'
end

load "./treetop.gemspec"

Rake::GemPackageTask.new($gemspec) do |pkg|
  pkg.need_tar = true
end

task :spec => :regenerate_metagrammar
task :regenerate_metagrammar => 'lib/treetop/compiler/metagrammar.treetop' do |t|
  unless $bootstrapped_gen_1_metagrammar
    load File.join(File.dirname(__FILE__), 'lib', 'treetop', 'bootstrap_gen_1_metagrammar.rb')
  end
  
  Treetop::Compiler::GrammarCompiler.new.compile(METAGRAMMAR_PATH)
end

task :version do
  puts RUBY_VERSION
end
