OPTIMIZE = false
TREETOP_ROOT = File.join(File.dirname(__FILE__), 'treetop')

require "rubygems"
require "inline"

require "#{TREETOP_ROOT}/utilities"
require "#{TREETOP_ROOT}/parser"
require "#{TREETOP_ROOT}/grammar"
require "#{TREETOP_ROOT}/ruby_extension"
require "#{TREETOP_ROOT}/metagrammar"
require "#{TREETOP_ROOT}/api"

