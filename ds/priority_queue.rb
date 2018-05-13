class PriorityQueue
  attr_reader :size

  def initialize(size, vals=[])
    raise RuntimeError, "Input array is bigger than #{size}" if vals.size() > size

    @keys = Array.new(size)
    if not vals.empty?
      vals.each_with_index {|val, i| @keys[i] = val }
      @size = vals.size
      make_heap
    else
      @size = 0
    end
  end

  def <<(val)
    @keys[@size] = val
    @size += 1
    bubble_up(@size-1)
  end

  def empty?()
    @size == 0
  end

  def peek()
    @keys[0]
  end

  def pop()
    out = @keys[0]
    @keys[0] = @keys[@size-1]
    @size -= 1
    bubble_down(0)
    out
  end

  private

  def swap(i, j)
    tmp = @keys[i]
    @keys[i] = @keys[j]
    @keys[j] = tmp
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
end

class MinPriorityQueue < PriorityQueue
  def ordered(parent, child)
    @keys[parent] <= @keys[child]
  end
end

class MaxPriorityQueue < PriorityQueue
  def ordered(parent, child)
    @keys[parent] >= @keys[child]
  end
end
