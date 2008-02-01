class Range
  def intersects?(other_range)
    return false if last <= other_range.first
    return false if first >= other_range.last
    true
  end
end