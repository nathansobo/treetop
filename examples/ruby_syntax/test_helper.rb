require 'test/unit'
require 'rubygems'
require 'treetop'

dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../../lib/treetop/ruby_extensions")
require File.expand_path("#{dir}/../../lib/treetop/syntax")

module SyntaxTestHelper
	def assert_grammar
		g = yield
		assert_not_nil g
		flunk "Badly generated parser" unless g
		@parser = eval("#{g}.new")
	end

	def parse(input)
		result = @parser.parse(input)
    unless result
      puts @parser.terminal_failures.join("\n")
    end
    assert_not_nil result
		if result
			assert_equal input, result.text_value
		end
    result
	end
end
