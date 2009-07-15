=begin rdoc
	Definition of TreeTop syntax in pure Ruby.
=end

module Treetop
	# Provides the possibility to write Treetop syntax as a Ruby code.
	# Symbols act as nonterminals, strings as terminals, arrays as
	# sequences. Ordered choices are defined similar to original Treetop
	# syntax.
	#
	# (Note: it is better not to use numbers; use Strings instead)
	#
	module Syntax
		class Grammar
			attr_reader :source
			def initialize
				@source = ""
			end

			def rule(name)
				@source += "rule #{name.to_s}\n#{yield.seq_to_tt.indent_paragraph(2)}\nend\n"
			end

			def include(name)
				@source += "include #{name.to_s}\n"
			end
		end

		def grammar(name, &block)
			Syntax.grammar(name, &block)
		end

		def self.grammar(name, &block)
			(g = Grammar.new).instance_eval(&block)
			source = "grammar #{name.to_s}\n#{g.source.indent_paragraph(2)}end\n"
			Treetop.load_from_string(source)
		end
	end
end
