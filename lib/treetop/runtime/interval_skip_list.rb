class IntervalSkipList
  def initialize
    @head = HeadNode.new(max_height)
  end

  def max_height
    3
  end

  def empty?
    head.forward[0].nil?
  end

  def insert(range, value)
    first_node = insert_node(range.first)
    last_node = insert_node(range.last)

    cur_node = first_node
    cur_level = first_node.height - 1
    while next_node_at_level_inside_range?(cur_node, cur_level, range)
      while can_ascend_from?(cur_node, cur_level) && next_node_at_level_inside_range?(cur_node, cur_level + 1, range)
        cur_level += 1
      end
      cur_node = mark_forward_path_at_level(cur_node, cur_level, value)
    end

    while node_inside_range?(cur_node, range)
      while can_descend_from?(cur_level) && next_node_at_level_outside_range?(cur_node, cur_level, range)
        cur_level -= 1 
      end
      cur_node = mark_forward_path_at_level(cur_node, cur_level, value)
    end
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

  protected
  attr_reader :head
  
  def insert_node(key)
    path = make_path
    found_node = find(key, path)
    if found_node && found_node.key == key
      return found_node
    else
      return Node.new(key, next_node_height, path)
    end
  end

  def delete(key)
    path = make_path
    found_node = find(key, path)
    found_node.remove(path) if found_node.key == key
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
    level < node.height - 1
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

  def mark_forward_path_at_level(node, level, value)
    node.values[level].push(value)
    next_node = node.forward[level]
    next_node.eq_values.push(value)
    node = next_node
  end

  class HeadNode
    attr_reader :height, :forward, :values

    def initialize(height)
      @height = height
      @forward = Array.new(height, nil)
      @values = Array.new(height) {|i| []}
    end
  end

  class Node < HeadNode
    attr_reader :key, :eq_values

    def initialize(key, height, path)
      super(height)
      @key = key
      @eq_values = []

      update_forward_pointers(path)
      promote_values(path)
    end

    def remove(path)
      0.upto(height - 1) do |i|
        path[i].forward[i] = forward[i]
      end
    end

    protected

    def update_forward_pointers(path)
      0.upto(height - 1) do |i|
        forward[i] = path[i].forward[i]
        path[i].forward[i] = self
      end
    end

    def promote_values(path)
      promoted = []
      new_promoted = []
      0.upto(height - 1) do |i|
        incoming_values = path[i].values[i]
        eq_values.concat(incoming_values)

        incoming_values.each do |value|
          if can_be_promoted_higher?(value, i)
            new_promoted.push(value)
            delete_value_from_path(value, i, forward[i+i])
          else
            values[i].push(value)
          end
        end

        promoted.each do |value|
          if can_be_promoted_higher?(value, i)
            new_promoted.push(value)
          else
            values[i].push(value)
          end
        end

        promoted = new_promoted
        new_promoted = []
      end
    end

    def can_be_promoted_higher?(value, level)
      level < height - 1 && forward[level + 1] && forward[level + 1].eq_values.include?(value)
    end

    def delete_value_from_path(value, level, terminus)
      cur_node = forward[level]
      until cur_node == terminus
        cur_node.values[level].delete(value)
        cur_node.eq_values.delete(value)
        cur_node = cur_node.forward[level]
      end
    end
  end
end