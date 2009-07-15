class Array
	def join_with(method, pattern = "")
		return join(pattern) unless method
		return "" if self.length == 0

		args = []
		if method.respond_to? :to_hash
			args = method[:args] || []
			method = method[:name]
		end

		output = self[0].send(method, *args)
		for i in (1...self.length)
			output += pattern + self[i].send(method, *args)
		end
		output
	end

	def to_tt
		self.join_with({:name => :seq_to_tt, :args => [true]}, " ")
	end
end
