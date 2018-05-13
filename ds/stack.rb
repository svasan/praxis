require_relative 'linked_list'

class Stack < LinkedList
  def each
    p = @last
    until p == nil
      yield p.val
      p = p.prev
    end
  end

  def pop
    return nil if @last.nil?
    out = @last
    @last = @last.prev
    @last.next = nil if not @last.nil?
    @size -= 1
    out.prev = nil
    out.val
  end

  def peek
    @last.val
  end
end
