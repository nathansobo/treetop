class Range
  def intersects?(other_range)
    return true if epsilon? && first == other_range.last
    return false if last <= other_range.first
    return false if first >= other_range.last
    true
  end
  
  def epsilon?
    first == last
  end

  def transpose(delta)
    (first + delta)..(last + delta)
  end
end