class BST

  class Node
    attr_accessor :left, :right
    attr_accessor :key, :value

    def initialize(key,value)
      @key = key
      @value = value
      @left = @right = nil
      # No. of nodes in the sub tree of which this node is the parent.
      @size = 1
    end

    def size
      @size
    end

    def left=(node)
      @left = node
      update_size
    end

    def right=(node)
      @right = node
      update_size
    end

    def to_s
      "{#{@key}=#{@value}, size=#{@size}, left_child=#{not @left.nil?}, right_child=#{not @right.nil?}}"
    end

    private
    def update_size
      @size = 0
      @size += @left.size if not @left.nil?
      @size += @right.size if not @right.nil?
      @size += 1
    end
  end

  def initialize
    @root = nil
  end

  def size
    return 0 if @root.nil?

    @root.size
  end

  def empty?
    return size() == 0
  end

  def get(key)
    __get(@root, key)
  end

  def put(key, value)
    @root = __put(key, value, @root)
  end

  def min
    return nil if @root.nil?

    min = @root
    while not min.left.nil?
      min = min.left
    end
    return min.key
  end

  def max
    return nil if @root.nil?

    max = @root
    while not max.right.nil?
      max = max.right
    end
    return max.key
  end

  def each(&b)
    __each_dfs(@root, &b)
  end

  # def each_bfs
  #   return if @root.nil?

  #   nodes = [@root]
  #   while not nodes.empty?
  #     node = nodes.shift
  #     yield node.key, node.value
  #     nodes << node.left if not node.left.nil?
  #     nodes << node.right if not node.right.nil?
  #   end
  # end

  # Keys in sorted ascending order
  def keys
    keys = []
    each do |key, value|
      keys << key
    end
    keys
  end

  def key_range(lo, hi)
    keys = []
    each do |key, value|
      keys << key if key >= lo and key <= hi
    end
    keys
  end

  def contains?(key)
    return !get(key).nil?
  end

  def delete(key)
    return nil if key.nil? or @root.nil?

    @root = __delete(key, @root)
  end

  def floor(key)
    return nil if key.nil? or @root.nil?

    node = __floor(key, @root)
    return nil if node.nil?
    node.key
  end

  def ceiling(key)
    return nil if key.nil? or @root.nil?

    node = __ceiling(key, @root)
    return nil if node.nil?
    node.key
  end

  def succ(key)
    return nil if key.nil? or @root.nil?

    node = __succ(key, @root)
    return nil if node.nil?
    node.key
  end

  def ancestor(key1, key2)
    return nil if key1.nil? or key2.nil? or @root.nil?

    node, _, _ = case key1 <=> key2
                 when -1, 0
                   __common_ancestor(key1, key2, @root)
                 when 1
                   __common_ancestor(key2, key1, @root)
                 end
    node.nil? ? nil : node.key
  end

  def to_s
    s = "["
    each {|k,v| s += "#{k}=#{v}, " }
    s.chomp!(", ")
    s += "]"
    s
  end

  private

  def __put(key, value, node)
    return Node.new(key, value) if node.nil?

    case key <=> node.key
    when -1
      node.left = __put(key, value, node.left)
    when 0
      node.value = value
    when 1
      node.right = __put(key, value, node.right)
    end
    node
  end

  def __get(node, key)
    return nil if node.nil?

    return case key <=> node.key
           when -1
             __get(node.left, key)
           when 0
             node.value
           when 1
             __get(node.right, key)
           end
  end

  def __each_dfs(node, &b)
    return if node.nil?

    __each_dfs(node.left, &b) if not node.left.nil?

    yield node.key, node.value

    __each_dfs(node.right, &b)
  end

  # returns [node, parent] of node that has the key
  # nil if key not found or root is nil.
  # If node is root, parent is nil
  def __delete(key, node)
    return nil if node.nil?

    if node.key == key
      if not node.left.nil?
        fnode = __floor(key, node.left)
        node.left = __delete(fnode.key, node.left)
        node.key = fnode.key
        node.value = fnode.value
      elsif not node.right.nil?
        rnode = __ceiling(key, node.right)
        node.right = __delete(rnode.key, node.right)
        node.key = rnode.key
        node.value = rnode.value
      else
        return nil
      end
    elsif key < node.key
      node.left = __delete(key, node.left)
    else
      node.right = __delete(key, node.right)
    end
    return node
  end

  def __floor(key, node)
    case key <=> node.key
    when 0
      return node
    when -1
      return nil if node.left.nil?
      __floor(key, node.left)
    when 1
      return node if node.right.nil?
      rnode = __floor(key, node.right)
      rnode.nil? ? node : rnode
    end
  end

  def __ceiling(key, node)
    case key <=> node.key
    when 0
      return node
    when -1
      return node if node.left.nil?
      lnode = __ceiling(key, node.left)
      lnode.nil? ? node : lnode
    when 1
      return nil if node.right.nil?
      __ceiling(key, node.right)
    end
  end


  def __succ(key, node)
    return nil if node.nil?

    case node.key <=> key
    when -1, 0
      return nil if node.right.nil?
       __succ(key, node.right)
    when 1
      return node if node.left.nil?
      succ = __succ(key, node.left)
      succ.nil? ? node : succ
    end
  end

  # Expects first <= second
  # return [ancestor, found_k1, found_k1]
  def __common_ancestor(first, second, node)
    return nil, nil, nil if node.nil?

    skip_right = skip_left = found_first = found_second = false
    case node.key <=> first
    when -1
      skip_left = true
    when 0
      found_first = skip_left = true
    when 1
      # Do nothing
    end

    case node.key <=> second
    when -1
      # Do nothing
    when 0
      skip_right = found_second = true
    when 1
      skip_right = true
    end

    if not skip_left
      ancestor, f1, s1 = __common_ancestor(first, second, node.left)
      return ancestor, f1, s1 if not ancestor.nil?

      return node, f1, s1 if f1 and s1

      found_first = f1 || found_first
      found_second = s1 || found_second
    end

    return nil, found_first, found_second if (found_first and found_second) or skip_right

    ancestor, f2, s2 = __common_ancestor(first, second, node.right)
    return ancestor, f2, s2 if not ancestor.nil?

    return node, f2, s2 if f2 and s2

    found_first = f2 || found_first
    found_second = s2 || found_second

    if found_first and found_second and node.key != first
      return node, found_first, found_second
    end

    return nil, found_first, found_second
  end
end
