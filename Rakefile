dir = File.dirname(__FILE__)
require 'rubygems'
require 'rake'
$LOAD_PATH.unshift(File.join(dir, 'vendor', 'rspec', 'lib'))
require 'spec/rake/spectask'

Gem::manage_gems
require 'rake/gempackagetask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.pattern = 'spec/**/*spec.rb'
end

gemspec = Gem::Specification.new do |s|
  s.name = "treetop"
  s.version = "1.2.4"
  s.author = "Nathan Sobo"
  s.email = "nathansobo@gmail.com"
  s.homepage = "http://functionalform.blogspot.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "A Ruby-based text parsing and interpretation DSL"
  s.files = FileList["README", "Rakefile", "{test,lib,bin,doc,examples}/**/*"].to_a
  s.bindir = "bin"
  s.executables = ["tt"]
  s.require_path = "lib"
  s.autorequire = "treetop"
  s.has_rdoc = false
  s.add_dependency "polyglot"
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
end
