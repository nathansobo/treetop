class IntervalSkipList
  attr_reader :head

  def initialize
    @head = Node.new(nil, max_height)
  end

  def max_height
    3
  end

  def empty?
    head.next[0].nil?
  end

  def insert(range, value)
    first_node = insert_node(range.first)
    last_node = insert_node(range.last)

    cur_node = first_node
    until cur_node == last_node
      (cur_node.values[0] ||= []).push(value)
      cur_node = cur_node.next[0]
    end
  end

  def insert_node(key)
    path = make_path
    found_node = find(key, path)
    if found_node && found_node.key == key
      return found_node
    else
      return make_node(key, path)
    end
  end

  def delete(key)
    path = make_path
    found_node = find(key, path)
    remove_node(found_node, path) if found_node.key == key
  end

  def nodes
    nodes = []
    cur_node = head.next[0]
    until cur_node.nil?
      nodes << cur_node
      cur_node = cur_node.next[0]
    end
    nodes
  end

  protected
  def find(key, path)
    cur_node = head
    (max_height - 1).downto(0) do |cur_height|
      while (next_node = cur_node.next[cur_height]) && next_node.key < key
        cur_node = next_node
      end
      path[cur_height] = cur_node
    end
    cur_node.next[0]
  end

  def make_node(key, path)
    new_node = Node.new(key, next_node_height)
    0.upto(new_node.height - 1) do |i|
      new_node.next[i] = path[i].next[i]
      path[i].next[i] = new_node
    end
    return new_node
  end

  def remove_node(node, path)
    0.upto(node.height - 1) do |i|
      path[i].next[i] = node.next[i]
    end
  end

  def make_path
    Array.new(max_height, nil)
  end

  def next_node_height
    nil
  end

  class Node
    attr_reader :key, :height, :next, :values

    def initialize(key, height)
      @key = key
      @height = height
      @next = Array.new(height, nil)
      @values = []
    end
  end
end