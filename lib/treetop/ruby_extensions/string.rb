class String
  def column_of(index)
    return 1 if index == 0
    newline_index = rindex("\n", index - 1)
    if newline_index
      index - newline_index
    else
      index + 1
    end
  end

  def line_of(index)
    self[0...index].count("\n") + 1
  end

  unless method_defined?(:blank?)
    def blank?
      self == ""
    end
  end

  # The following methods are lifted from Facets 2.0.2
  def tabto(n)
    if self =~ /^( *)\S/
      indent(n - $1.length)
    else
      self
    end
  end

  def indent(n)
    if n >= 0
      gsub(/^/, ' ' * n)
    else
      gsub(/^ {0,#{-n}}/, "")
    end
  end

	def indent_paragraph(n)
		out = ""
		self.each_line {|line| out += line.indent(n) }
		out
	end

	# Removes indentation uniformly.
	def justify
		min = self.length
		self.each_line {|line|
			next if line.strip == ""
			if line =~ /^(  *)\S/
				min = $1.length if min > $1.length
			else
				min = 0
			end
		}
		out = ""
		self.each_line {|line| out += line.slice(min...line.length) || "\n" }
		out.strip
	end

  def treetop_camelize
    to_s.gsub(/\/(.?)/){ "::" + $1.upcase }.gsub(/(^|_)(.)/){ $2.upcase }
  end

	def to_tt
		"'#{self}'"
	end
end
