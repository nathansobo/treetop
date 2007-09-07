dir = File.dirname(__FILE__)

TREETOP_ROOT = File.join(dir, 'treetop')
require File.join(TREETOP_ROOT, "ruby_extensions")
require File.join(TREETOP_ROOT, "parser")
require File.join(TREETOP_ROOT, "compiler")