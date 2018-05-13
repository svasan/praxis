class LinkedList
  include Enumerable

  def initialize
    @first = @last = nil
    @size = 0
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
