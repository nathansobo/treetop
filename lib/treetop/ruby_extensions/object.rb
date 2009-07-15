class Object
	def sequence
		@sequence ||= []
	end

	def /(other)
		sequence.push(other)
		self
	end

	def seq_to_tt(inline = false)
		separator = inline ? " / " : "\n/\n"
		tt = if sequence.length == 0
			self.to_tt
		else
			output = self.to_tt + separator + sequence.join_with({:name => :seq_to_tt, :args => [true]}, separator)
			output = "( #{output} )" if inline
			output
		end

		# Operators
		tt = "&" + tt if @amper
		tt = "!" + tt if @bang
		tt += "*" if @kleene
		tt += "+" if @plus
		tt += "?" if @mark

		tt += " <#{@node.to_s}>" if @node
		tt += " {\n#{@block.gsub("\t", "  ").justify.indent_paragraph(2)}\n}" if @block
		tt = @label.to_s + ':' + tt if @label
		tt
	end

	def node(name)
		@node = name
		self
	end

	def block(content)
		@block = content
		self
	end

	def label(name)
		@label = name
		self
	end

	[:mark, :kleene, :plus, :amper, :bang].each do |sym|
		Object.class_eval(%{
			def #{sym.to_s}
				@#{sym.to_s} = true
				self
			end
		})
	end
end
