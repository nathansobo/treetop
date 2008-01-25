class IntervalSkipList
  def initialize
    @head = HeadNode.new(max_height)
    @ranges = {}
  end

  def max_height
    3
  end

  def empty?
    head.forward[0].nil?
  end

  def containing(n)
    containing = []
    cur_node = head
    (max_height - 1).downto(0) do |cur_level|
      while (next_node = cur_node.forward[cur_level]) && next_node.key <= n
        cur_node = next_node
        if cur_node.key == n
          return containing + (cur_node.markers - cur_node.endpoint_of)
        end
      end
      containing.concat(cur_node.forward_markers[cur_level])
    end
    containing
  end

  def insert(range, marker)
    ranges[marker] = range
    first_node = insert_node(range.first)
    first_node.endpoint_of.push(marker)
    last_node = insert_node(range.last)
    last_node.endpoint_of.push(marker)

    cur_node = first_node
    cur_level = first_node.top_level
    while next_node_at_level_inside_range?(cur_node, cur_level, range)
      while can_ascend_from?(cur_node, cur_level) && next_node_at_level_inside_range?(cur_node, cur_level + 1, range)
        cur_level += 1
      end
      cur_node = mark_forward_path_at_level(cur_node, cur_level, marker)
    end

    while node_inside_range?(cur_node, range)
      while can_descend_from?(cur_level) && next_node_at_level_outside_range?(cur_node, cur_level, range)
        cur_level -= 1 
      end
      cur_node = mark_forward_path_at_level(cur_node, cur_level, marker)
    end
  end

  def delete(marker)
    range = ranges[marker]
    path_to_first_node = make_path
    first_node = find(range.first, path_to_first_node)

    cur_node = first_node
    cur_level = first_node.top_level
    while next_node_at_level_inside_range?(cur_node, cur_level, range)
      while can_ascend_from?(cur_node, cur_level) && next_node_at_level_inside_range?(cur_node, cur_level + 1, range)
        cur_level += 1
      end
      cur_node = unmark_forward_path_at_level(cur_node, cur_level, marker)
    end

    while node_inside_range?(cur_node, range)
      while can_descend_from?(cur_level) && next_node_at_level_outside_range?(cur_node, cur_level, range)
        cur_level -= 1
      end
      cur_node = unmark_forward_path_at_level(cur_node, cur_level, marker)
    end
    last_node = cur_node

    first_node.endpoint_of.delete(marker)
    if first_node.endpoint_of.empty?
      first_node.delete(path_to_first_node)
    end

    last_node.endpoint_of.delete(marker)
    if last_node.endpoint_of.empty?
      path_to_last_node = make_path
      find(range.last, path_to_last_node)
      last_node.delete(path_to_last_node)
    end
  end

  protected
  attr_reader :head, :ranges
  
  def insert_node(key)
    path = make_path
    found_node = find(key, path)
    if found_node && found_node.key == key
      return found_node
    else
      return Node.new(key, next_node_height, path)
    end
  end

  def delete_node(key)
    path = make_path
    found_node = find(key, path)
    found_node.delete(path) if found_node.key == key
  end
  
  def find(key, path)
    cur_node = head
    (max_height - 1).downto(0) do |cur_level|
      while (next_node = cur_node.forward[cur_level]) && next_node.key < key
        cur_node = next_node
      end
      path[cur_level] = cur_node
    end
    cur_node.forward[0]
  end

  def make_path
    Array.new(max_height, nil)
  end

  def next_node_height
    nil
  end

  def can_ascend_from?(node, level)
    level < node.top_level
  end

  def can_descend_from?(level)
    level > 0
  end

  def node_inside_range?(node, range)
    node.key < range.last
  end

  def next_node_at_level_inside_range?(node, level, range)
    node.forward[level] && node.forward[level].key <= range.last
  end

  def next_node_at_level_outside_range?(node, level, range)
    (node.forward[level].nil? || node.forward[level].key > range.last)
  end

  def mark_forward_path_at_level(node, level, marker)
    node.forward_markers[level].push(marker)
    next_node = node.forward[level]
    next_node.markers.push(marker)
    node = next_node
  end

  def unmark_forward_path_at_level(node, level, marker)
    node.forward_markers[level].delete(marker)
    next_node = node.forward[level]
    next_node.markers.delete(marker)
    node = next_node
  end

  def nodes
    nodes = []
    cur_node = head.forward[0]
    until cur_node.nil?
      nodes << cur_node
      cur_node = cur_node.forward[0]
    end
    nodes
  end 
end