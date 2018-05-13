require_relative 'stack'
require_relative 'que'
require_relative 'priority_queue'
require_relative 'indexed_priority_queue'
require 'test/unit'

class TestDS < Test::Unit::TestCase


  def test_stack
    stack = Stack.new
    1.upto(10) do |i|
      stack << i
    end
    vals = []
    stack.each do |i|
      vals << i
    end
    assert_equal((1..10).to_a.reverse, vals, "Did not iterate stack correctly")
  end

  def test_queue
    queue = Que.new
    1.upto(10) do |i|
      queue << i
    end
    vals = []
    queue.each do |i|
      vals << i
    end
    assert_equal((1..10).to_a, vals, "Did not iterate queue correctly")
  end

  def test_min_pq
    vals = (1..10).to_a.shuffle
    pq = MinPriorityQueue.new(10, vals)
    out = []
    until pq.empty?
      out << pq.pop()
    end
    assert_equal((1..10).to_a, out, "Was not sorted correctly")
  end

  def test_max_pq
    vals = (1..10).to_a.shuffle
    pq = MaxPriorityQueue.new(10, vals)
    out = []
    until pq.empty?
      out << pq.pop()
    end
    assert_equal((1..10).to_a.reverse, out, "Was not sorted correctly")
  end

  def test_indexed_min_pq
    vals = (1..10).to_a.shuffle.map {|i| [(10-i+1).abs, i]}
    pq = IndexedMinPriorityQueue.new(10, vals)
    out = []
    until pq.empty?
      out << pq.pop()
    end
    expected = (1..10).to_a.reverse.zip((1..10).to_a)
    assert_equal(expected, out, "Was not sorted correctly")

    # Update
    vals = (1..10).to_a.shuffle.map {|i| [(10-i+1).abs, i]}
    pq = IndexedMinPriorityQueue.new(10, vals)
    out = []
    (1..10).each {|i| pq << [i, i] }
    until pq.empty?
      out << pq.pop()
    end
    expected = (1..10).to_a.zip((1..10).to_a)
    assert_equal(expected, out, "Was not sorted correctly")
  end

  def test_indexed_max_pq
    vals = (1..10).to_a.shuffle.map {|i| [(10-i+1).abs, i]}
    pq = IndexedMaxPriorityQueue.new(10, vals)
    out = []
    until pq.empty?
      out << pq.pop()
    end
    expected = (1..10).to_a.zip((1..10).to_a.reverse)
    assert_equal(expected, out, "Was not sorted correctly")

    # Update
    vals = (1..10).to_a.shuffle.map {|i| [(10-i+1).abs, i]}
    pq = IndexedMaxPriorityQueue.new(10, vals)
    out = []
    (1..10).each {|i| pq << [i, i] }
    until pq.empty?
      out << pq.pop()
    end
    expected = (1..10).to_a.reverse.zip((1..10).to_a.reverse)
    assert_equal(expected, out, "Was not sorted correctly")
  end
end
