class IntervalSkipList
  attr_reader :nodes

  def initialize
    @node_heights = [3, 1, 2, 1, 3, 1, 2, 2]
    @nodes = []
  end

  def empty?
    nodes.empty?
  end

  def insert(value)
    nodes << Node.new(value, next_node_height)
  end

  protected
  attr_reader :node_heights

  def next_node_height
    height = node_heights.shift
  end

  class Node
    attr_reader :value, :height

    def initialize(value, height)
      @value = value
      @height = height
    end
  end
end