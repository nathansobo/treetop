class String
  def column_of(index)
    return 0 if index == 0
    
    column = 0
    
    while index > 0 && self[index - 1] != 10 do
      column += 1
      index -= 1
    end
    
    column
  end
end