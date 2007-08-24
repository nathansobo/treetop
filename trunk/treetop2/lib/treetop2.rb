dir = File.dirname(__FILE__)

require File.expand_path('treetop', File.join(dir, *%w[.. .. lib]))
TREETOP_2_ROOT = File.join(dir, 'treetop2')
require File.join(TREETOP_2_ROOT, "parser")
require File.join(TREETOP_2_ROOT, "compiler")
require File.join(TREETOP_2_ROOT, "compiler_2")