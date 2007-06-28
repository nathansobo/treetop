dir = File.dirname(__FILE__)
require "#{dir}/../lib/treetop"

load_grammar "#{dir}/arithmetic"

parser = Arithmetic.new_parser

node = parser.parse("1+3+5")

puts node.success?
puts node.value

