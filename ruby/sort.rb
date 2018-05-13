module Sort
  def self.isort(a)
    for i in 1..a.size-1 do
      x = a[i]
      j = i-1
      until j < 0 || a[j] < x
        a[j+1] = a[j]
        j -= 1
      end
      a[j+1] = x
    end
    a
  end

  def self.heapsort(a)
    for last in (1..a.size-1).to_a.reverse do
      make_heap(a, last)
      swap(a, 0, last)
    end
    a
  end

  def self.qsort(a)
    _qsort(a, 0, a.size-1)
    a
  end

  class << self
    private
    def make_heap(a, last)
      return if last == 0

      i = last/2
      i -= 1 if last%2 == 0

      for n in (0..i).to_a.reverse do
        while true
          lchild = 2*n + 1;
          rchild = 2*n + 2;
          break if lchild > last

          max = rchild > last || a[lchild] > a[rchild] ? lchild : rchild
          break if a[n] >= a[max]

          swap(a, n, max)
          n = max
        end
      end
    end

    def swap(a, i, j)
      tmp = a[i]
      a[i] = a[j]
      a[j] = tmp
    end

    def _qsort(a, start, last)

      return if start == last

      if last == start+1
        swap(a, start, last) if a[start] > a[last]
        return
      end

      pi, pv = _pivot(a, start, last)
      swap(a, start, pi) if pi != start

      i = start+1
      j = last
      until i >= j
        i +=1 while a[i] < pv
        j -=1 while a[j] >= pv
        if (i < j)
          swap(a, i, j)
          i += 1
          j -= 1
        end
      end
      swap(a, start, j)
      _qsort(a, start, j-1)
      _qsort(a, j+1, last)
    end

    def _pivot(a, start, last)
      return start, a[start] if a[start] == a[last]

      mid = (start+last)/2
      if a[start] < a[last]
        if a[start] >= a[mid]
          return start, a[start]
        elsif a[mid] <= a[last]
          return mid, a[mid]
        else
          return last, a[last]
        end
      else
        if a[last] >= a[mid]
          return last, a[last]
        elsif a[mid] <= a[start]
          return mid, a[mid]
        else
          return start, a[start]
        end
      end
    end
  end
end
