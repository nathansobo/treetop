$:.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))
require 'rubygems'
require 'spec'

require 'treetop'

include Treetop