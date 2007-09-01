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
end