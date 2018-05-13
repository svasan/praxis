require_relative 'linked_list'

class Que < LinkedList
  def each
    p = @first
    until p == nil
      yield p.val
      p = p.next
    end
  end

  def pop
    return nil if @first.nil?
    out = @first
    @first = @first.next
    @first.prev = nil if not @first.nil?
    @size -= 1
    out.next = nil
    out.val
  end

  def peek
    @first.val
  end
end
