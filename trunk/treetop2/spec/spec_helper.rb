$:.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))
require 'rubygems'
require 'spec'

require 'treetop2'

include Treetop2