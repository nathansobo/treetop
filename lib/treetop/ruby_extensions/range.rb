class Range
  def intersects?(other_range)
    if exclude_end?
      return false if last <= other_range.first || first >= other_range.last
    else
      return false if last < other_range.first || first > other_range.last
    end
    true
  end

  def transpose(delta)
    (first + delta)..(last + delta)
  end
end