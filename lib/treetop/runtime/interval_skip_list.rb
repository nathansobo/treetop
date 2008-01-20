class IntervalSkipList
  attr_reader :head

  def initialize
    @head = Node.new(nil, max_height)
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
    while cur_node.forward[cur_level] && cur_node.forward[cur_level].key <= range.last
      cur_node.values[cur_level].push(value)
      next_node = cur_node.forward[cur_level]
      next_node.eq_values.push(value)
      cur_node = next_node
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
    cur_node = head.forward[0]
    until cur_node.nil?
      nodes << cur_node
      cur_node = cur_node.forward[0]
    end
    nodes
  end

  protected
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

  def make_node(key, path)
    new_node = Node.new(key, next_node_height)
    0.upto(new_node.height - 1) do |i|
      new_node.forward[i] = path[i].forward[i]
      path[i].forward[i] = new_node
    end
    new_node.promote_values(path)
    return new_node
  end

  def remove_node(node, path)
    0.upto(node.height - 1) do |i|
      path[i].forward[i] = node.forward[i]
    end
  end

  def make_path
    Array.new(max_height, nil)
  end



  def next_node_height
    nil
  end

  class Node
    attr_reader :key, :height, :forward, :values, :eq_values

    def initialize(key, height)
      @key = key
      @height = height
      @forward = Array.new(height, nil)
      @values = Array.new(height) {|i| []}
      @eq_values = []
    end

    def promote_values(path)
      promoted = []
      new_promoted = []
      0.upto(height - 1) do |i|
        incoming_values = path[i].values[i]
        eq_values.concat(incoming_values)
        incoming_values.each do |value|
          if i < height - 1 && forward[i + 1] && forward[i + 1].eq_values.include?(value)
            new_promoted.push(value)
            # delete lower path
          else
            values[i].push(value)
          end
        end

        promoted.each do |value|
          if i < height - 1 && forward[i + 1] && forward[i + 1].eq_values.include?(value)
            new_promoted.push(value)
          else
            values[i].push(value)
          end
        end

        promoted = new_promoted
        new_promoted = []
      end
    end
  end
end