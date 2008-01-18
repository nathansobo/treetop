class IntervalSkipList
  attr_reader :head

  def initialize
    @head = Node.new(nil, max_height)
  end

  def max_height
    3
  end

  def empty?
    nodes.empty?
  end

  def insert(value)
    path = Array.new(max_height, nil)
    found_node = find(value, path)
    if found_node && found_node.value == value
      return found_node
    else
      return make_node(value, path)
    end
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
  def find(value, path)
    cur_node = head
    (max_height - 1).downto(0) do |cur_height|
      while (next_node = cur_node.next[cur_height]) && next_node.value < value
        cur_node = next_node
      end
      path[cur_height] = cur_node
    end
    cur_node.next[0]
  end

  def make_node(value, path)
    new_node = Node.new(value, next_node_height)
    0.upto(new_node.height - 1) do |i|
      new_node.next[i] = path[i].next[i]
      path[i].next[i] = new_node
    end
    return new_node
  end

  def next_node_height
    nil
  end

  class Node
    attr_reader :value, :height, :next

    def initialize(value, height)
      @value = value
      @height = height
      @next = Array.new(height, nil)
    end
  end
end