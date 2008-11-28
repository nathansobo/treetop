$gemspec = Gem::Specification.new do |s|
  s.name = "treetop"
  s.version = "1.2.5"
  s.author = "Nathan Sobo"
  s.email = "nathansobo@gmail.com"
  s.homepage = "http://functionalform.blogspot.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "A Ruby-based text parsing and interpretation DSL"
  s.files = ["README", "Rakefile", "{test,lib,bin,doc,examples}/**/*"].map{|p| Dir[p]}.flatten
  s.bindir = "bin"
  s.executables = ["tt"]
  s.require_path = "lib"
  s.autorequire = "treetop"
  s.has_rdoc = false
  s.add_dependency "polyglot"
end

