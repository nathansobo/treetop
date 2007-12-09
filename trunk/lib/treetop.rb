require 'rubygems'

if require 'polyglot'
  Polyglot.register("treetop",
      Class.new do
	def self.load(file)
	  Treetop.load_grammar file
	end
      end
    )
end
require 'facets/string/tabs'
require 'facets/stylize'

dir = File.dirname(__FILE__)

TREETOP_ROOT = File.join(dir, 'treetop')
require File.join(TREETOP_ROOT, "ruby_extensions")
require File.join(TREETOP_ROOT, "runtime")
require File.join(TREETOP_ROOT, "compiler")
