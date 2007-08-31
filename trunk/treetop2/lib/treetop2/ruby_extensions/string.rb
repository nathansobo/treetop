class String
  def column_of(index)
    return 0 if index == 0
    newline_index = rindex("\n", index - 1)
    if newline_index
      index - newline_index - 1
    else
      index
    end
  end
  
  def line_of(index)
    self[0...index].count("\n")
  end
end