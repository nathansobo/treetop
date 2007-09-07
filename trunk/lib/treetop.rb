dir = File.dirname(__FILE__)

TREETOP_2_ROOT = File.join(dir, 'treetop')
require File.join(TREETOP_2_ROOT, "ruby_extensions")
require File.join(TREETOP_2_ROOT, "parser")
require File.join(TREETOP_2_ROOT, "compiler")