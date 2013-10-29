class TreeNode

  attr_accessor :value, :parent, :children
  attr_reader :max_children

  def initialize(value, parent, max_children)
    @value = value
    @parent = parent
    @children = []
    @max_children = max_children
  end

  def full?
    children.length == max_children
  end

  def get_child(index)
    children[index]
  end

  def add_child(child)
    children << child
  end

  def to_s
    "#{@value}"
  end

end

class Tree

  attr_reader :max_children

  def initialize(max_children = 2)
    @tree_array = []
    @max_children = max_children
  end

  def add_node(value, node_max_children = max_children)
    parent = parent_search
    new_node = TreeNode.new(value, parent, node_max_children)

    if parent.nil?
      # for the first node, there is no parent to add this to (it is the first)
    else
      parent.add_child(new_node)
    end

    @tree_array << new_node
  end

  def parent_search
    return nil if @tree_array.empty?

    @tree_array.each do |parent_node|
      next if parent_node.full?

      return parent_node
    end
  end

  def dfs_recursive(search_queue, block)
    return nil if search_queue.empty?

    p search_queue
    node = search_queue.shift

    return node if block.call(node.value)

    node.children.reverse.each do |child|
      search_queue.unshift(child)
    end

    found_node = dfs_recursive(search_queue, block)

    found_node
  end

  def dfs(*search_value, &block)
    block ||= Proc.new { |value| value == search_value.first }

    dfs_recursive([@tree_array.first], block)
  end

  def bfs_recursive(search_queue, proc)
    return nil if search_queue.empty?

    node = search_queue.shift
    return node if proc.call(node.value) # { |value| value > 8 }

    search_queue += node.children

    found_node = bfs_recursive(search_queue, proc)
    found_node
  end

  def bfs(*search_value, &block)
    block ||= Proc.new { |value| value == search_value.first }

    search_queue = [@tree_array.first]
    bfs_recursive(search_queue, block)
  end

  def step_count(board_node)
    return 0 if board_node.parent.nil?

    1 + step_count(board_node.parent)
  end

  def get_source(end_node, source_offset)
    target_node = end_node

    until step_count(target_node) <= source_offset
      target_node = target_node.parent
    end

    target_node.value
  end

  def print_tree
    current_level = 1
    next_level = 1


    @tree_array.each do |node|

      puts "value:#{node.value}   children: #{node.children.join(" ")}"
      # if current_level == next_level
      #   puts ""
      #   next_level = next_level ** 2
      # end
      # current_level += 1
    end
  end

end

# tree = Tree.new(2)
#
# tree.add_node(0)
# tree.add_node(4)
# tree.add_node(7)
# tree.add_node(8)
# tree.add_node(6)
# tree.add_node(2)
# tree.add_node(5)
# tree.add_node(9)
#
# tree.print_tree
# puts "---------BFS SEARCH START----------"
# p tree.bfs(6)
# puts "---------DFS SEARCH START----------"
# p tree.dfs(6).value

#p tree.dfs { |value| value == 6 }

#p tree.bfs { |value| value > 8 }
#p tree.dfs { |value| (1..4) === value  }