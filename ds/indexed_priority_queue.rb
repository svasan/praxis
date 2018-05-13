class IndexedPriorityQueue
  attr_reader :size

  def initialize(size, vals=[])
    raise RuntimeError, "Input array is bigger than #{size}" if vals.size() > size

    @keys = Array.new(size)
    # @index[i] is the index of @keys[i]
    @index = Array.new(size)
    # Gives the position in the array of the key for index i. (ie)
    # @index2key[i] = k such that @index[k] = i and @keys[k] is the key associated with index i
    @index2key = Array.new(size)
    if not vals.empty?
      vals.each_with_index do |arr, i|
        idx,val  = arr
        raise RuntimeError, "Index #{idx} is not less than #{size-1}" if i >= size
        @keys[i] = val
        @index[i] = idx
        @index2key[idx] = i
      end
      @size = vals.size
      make_heap
    else
      @size = 0
    end
  end

  def <<(iv)
    i, val = iv

    return update(i,val) if has_index?(i)

    @keys[@size] = val
    @index[@size] = i
    @index2key[i] = @size
    @size += 1
    bubble_up(@size-1)
  end

  def empty?()
    @size == 0
  end

  def peek()
    [@index[0], @keys[0]]
  end

  def has_index?(i)
    not @index2key[i].nil?
  end

  def pop()
    return nil, nil if empty?

    out = @keys[0]
    idx = @index[0]
    @index2key[idx] = nil

    if @size > 1
      @keys[0] = @keys[@size-1]
      @index[0] = @index[@size-1]
      @index2key[@index[0]] = 0
    end
    @size -= 1
    bubble_down(0)
    [idx, out]
  end

  private

  def swap(i, j)
    #keys
    tmp = @keys[i]
    @keys[i] = @keys[j]
    @keys[j] = tmp

    # index
    tmp = @index[i]
    @index[i] = @index[j]
    @index[j] = tmp

    # index2key
    @index2key[@index[i]] = i
    @index2key[@index[j]] = j
  end

  def bubble_up(n)
    return if n >= @size

    until n <= 0
      parent = n/2
      parent -= 1 if n%2 == 0
      break if ordered(parent, n)
      swap(parent, n)
      n = parent
    end
  end

  def bubble_down(parent)
    done = false
    until done
      rchild = 2*parent + 2
      lchild = rchild - 1
      break if lchild >= @size
      if rchild >= @size or ordered(lchild, rchild)
        max_child = lchild
      else
        max_child = rchild
      end
      done = ordered(parent, max_child)
      if not done
        swap(parent, max_child)
        parent = max_child
      end
    end
  end

  def make_heap
    n = @size - 1
    n -= 1 if n%2 == 0
    n /= 2
    until n < 0
      bubble_down(n)
      n -= 1
    end
  end

  def update(i, new_val)
    pos = @index2key[i]
    old_val = @keys[pos]
    @keys[pos] = new_val
    if compare(new_val, old_val)
      # New val is lesser (greater) than old value for min (max) queue.
      # Below is fine. Have to bubble up.
      bubble_up(pos)
    else
      # New value is lesser/greater (for min/max resp.) which means up
      # is okay but have to bubble down.
      bubble_down(pos)
    end
  end

  def ordered(parent, child)
    compare(@keys[parent], @keys[child])
  end
end

class IndexedMinPriorityQueue < IndexedPriorityQueue
  private
  def compare(i, j); i <= j; end
end

class IndexedMaxPriorityQueue < IndexedPriorityQueue
  private
  def compare(i, j); i>=j; end
end
