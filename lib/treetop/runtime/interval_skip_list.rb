class IntervalSkipList
  attr_reader :nodes, :head

  def initialize
    @node_heights = [3, 1, 2, 1, 3, 1, 2, 2]
    @nodes = []
    @head = Node.new(nil, max_height)
  end

  def max_height
    3
  end

  def empty?
    nodes.empty?
  end

  def insert(value)
    node = Node.new(value, next_node_height)
    nodes << node
    0.upto(node.height - 1) do |i|
      head.next[i] = node
    end
  end

  protected
  attr_reader :node_heights

  def next_node_height
    height = node_heights.shift
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