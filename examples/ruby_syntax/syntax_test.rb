dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/test_helper")

class SyntaxTest < Test::Unit::TestCase
	include Treetop::Syntax
	include SyntaxTestHelper

	def test_simple
		assert_grammar {
			grammar :OnlyGrammar do
			end
		}
	end

	def test_rules
		assert_grammar {
			grammar :Simple do
				rule :foo do
					["foo", :bar]
				end

				rule :bar do
					"bar" / "baz"
				end
			end
		}
		parse('foobar')
		parse('foobaz')
	end

	def test_nested
		assert_grammar {
			grammar :Nested do
				rule :nested do
					["foo", "bar", "baz" / "bop"]
				end
			end
		}
		parse('foobarbaz')
		parse('foobarbop')
	end

	def test_operators
		assert_grammar {
			grammar :Kleene do
				rule :Kleene do
					"foo".kleene
				end
			end
		}
		parse("")
		parse("foo")
		parse("foofoo")

		assert_grammar {
			grammar :Plus do
				rule :Plus do
					"foo".plus
				end
			end
		}
		parse("foo")
		parse("foofoo")

		assert_grammar {
			grammar :Optional do
				rule :Optional do
					"foo".mark
				end
			end
		}
		parse("")
		parse("foo")
	end

	def test_inclusion
		assert_grammar {
			grammar :One do
				rule :a do
					"foo"
				end

				rule :b do
					"baz"
				end
			end
		}

		assert_grammar {
			grammar :Two do
				include :One
				rule :a do
					:super / "bar" / :c
				end

				rule :c do
					:b
				end
			end
		}
		parse("foo")
		parse("bar")
		parse("baz")
	end
end
