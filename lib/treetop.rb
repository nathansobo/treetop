module Treetop
  VALID_GRAMMAR_EXT = ['treetop', 'tt']
  VALID_GRAMMAR_EXT_REGEXP = /\.(#{VALID_GRAMMAR_EXT.join('|')})\Z/o
end

require 'treetop/runtime'
require 'treetop/compiler'

require 'polyglot'
Polyglot.register(Treetop::VALID_GRAMMAR_EXT, Treetop)
