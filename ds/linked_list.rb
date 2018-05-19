class LinkedList
  include Enumerable
  include Comparable

  def initialize(coll = [])
    @first = @last = nil
    @size = 0
    coll.each { |e|  self << e}
  end

  def <<(item)
    n = Node.new(@last, nil, item)
    @first = n if @first.nil?
    @last.next = n if not @last.nil?
    @last = n
    @size += 1
    self
  end

  def clear
    @first = @last = nil
    self
  end

  def size
    @size
  end

  def empty?
    @size == 0
  end

  def to_a
    a = []
    each do |v|
      a << v
    end
    a
  end

  def <=>(other)
    return nil if not other.instance_of?(self.class)

    min_size = size <= other.size ? size : other.size
    o_enum = other.to_enum
    s_enum = to_enum

    0.upto(min_size-1) do
      s = s_enum.next
      o = o_enum.next
      next if s == o
      return s <=> o
    end

    return size <=> other.size
  end

  def to_s
    s = "["
    each do |val|
      s += "#{val},"
    end
    s.chomp!(',')
    s += "]"
    s
  end
  alias_method :inspect, :to_s

  class Node
    attr_accessor :prev, :next, :val

    def initialize(prev=nil, _next=nil, val=nil)
      @val = val
      @prev = prev
      @next = _next
    end
  end
end
