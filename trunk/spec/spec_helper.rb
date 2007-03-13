dir = File.dirname(__FILE__)
require "#{dir}/../lib/treetop"

include Treetop

def h(text)
  text.inspect.gsub(/</, '&lt;').gsub(/>/, '&gt;')
end
