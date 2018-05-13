a2d = [[1, 2,3, 4],
       ["a", "b", "c", "d"],
       [{some: "value"}, {other: "value"}]
      ]

puts "a2d: #{a2d}"
puts "1..-1: #{a2d[1..-1]}"
puts "0..-1: #{a2d[0..-1]}"
puts "-1..1: #{a2d[-1..1]}"
puts "0...1: #{a2d[0...1]}"
puts "Array.find: #{a2d[0].find(1)}"
puts "Array.find {} : #{a2d[0].find(1) {|i| i}}"

puts "Array.new(3): #{Array.new(3)}"

puts "Array.new(4,0): #{Array.new(4,0)}"

puts "Array.new(4) {|i| i }: #{Array.new(4) {|i| i}}"

puts "take until nil: #{[1,2,3,nil].take_while {|i| i}}"

class Card
  attr_accessor :color, :shade, :count

  def initialize(color, shade, count)
    @color = color
    @shade = shade
    @count = count
  end
end


class Game
    def is_set(cards)
      cards.map do |c|
        [c.color, c.shade, c.count ]
      end.transpose.map do |a|
#      values.transpose.map do |a|
#      values[0].zip(values[1], values[2]).map do |a|
        (a[0] == a[1] && a[0] == a[2]) ||
          (a[0] != a[1] && a[1] != a[2] && a[0] != a[2])
      end.all?(true)
    end

    def is_set_2(cards)
      iters = cards.map do |c|
        [c.color, c.shade, c.count ]
      end.map  do |a|
        a.to_enum
      end

      result = []
      loop {
        a = iters.map {|i| i.next }
        result <<   ((a[0] == a[1] && a[0] == a[2]) ||
                     (a[0] != a[1] && a[1] != a[2] && a[0] != a[2]))
      }
      result.all?
    end
end

set_cards = [Card.new("black", "solid", 3),
         Card.new("black", "solid", 3),
         Card.new("black", "solid", 3)]

puts "#{Game.new.is_set_2(set_cards)}"

set_cards_2 = [Card.new("black", "solid", 3),
         Card.new("purple", "dots", 4),
         Card.new("white", "dash", 5)]

puts "#{Game.new.is_set_2(set_cards_2)}"


# n = @hash[key].find {|v| v.time >= time}
# return nil if n.nil?
# n .val

num = []
0.upto(3) do |i|
  num[i] = []
  0.upto(3) do |j|
    num[i] << (i+1)*(j+1)
  end
end
puts "#{num}"

num = []
4.times do |i|
  num[i] = []
  4.times do |j|
    num[i] << (i+1) * (j+1)
  end
end
puts "#{num}"

num = []
3.downto(0) do |i|
  num[i] = []
  3.downto(0) do |j|
    num[i] << (i+1) * (j+1)
  end
end
puts "#{num}"


num.each do |arr|
  arr.map! {|n| n*n }
end
puts "#{num}"

num.each do |arr|
  arr.reject! { |n| n%3 == 0}
end
puts "#{num}"

num.select! do |arr|
  !arr.empty? && arr.none? { |n| n == 1}
end
puts "#{num}"

num.select! do |arr|
  arr.any? { |n| n < 50 } && arr.one? { |n| n > 200}
end
puts "#{num}"


def transpose(matrix)
  raise RuntimeError, "Not a NxN matrix" if matrix.size != matrix[0].size
  n = matrix.size
  for i in (0..(n-1)/2) do
    for j in (i..n-1-i) do
      next if i == j
      tmp = matrix[i][j]
      matrix[i][j] = matrix[n-1-j][i]
      matrix[n-1-j][i] = matrix[n-1-i][n-1-j]
      matrix[n-1-i][n-1-j] = matrix[j][n-1-i]
      matrix[j][n-1-i] = tmp
    end
  end
end

matrix = []
(0..4).each do |i|
  matrix[i] = []
  (0..4).each do |j|
    matrix[i][j] = i+j
  end
end

matrix.each do |row|
  puts "#{row}"
end
transpose(matrix)
matrix.each do |row|
  puts "#{row}"
end

require_relative '../ds/stack.rb'

class SetOfStacks
  def initialize(size)
    @size = size
    @stacks = Stack.new()
  end

  def empty?
    @stacks.empty? or (@stacks.size == 1 and @stacks.peek.empty?)
  end

  def <<(val)
    if @stacks.empty? or @stacks.peek.size == @size
      @stacks << Stack.new()
    end
    @stacks.peek << val
  end

  def pop
    until @stacks.empty? or not @stacks.peek.empty?
      @stacks.pop
    end
    return nil if @stacks.empty?

    @stacks.peek.pop
  end

  def to_s
    s=""
    @stacks.each do |st|
      s += "#{st}"
    end
    s
  end
end

ss = SetOfStacks.new(5)
(1..25).each do |i|
  ss << i
end
puts "#{ss}"

out = []
#(1..25).each do
until ss.empty?
  val = ss.pop()
  out << val
end
puts "#{out}"

def toh(a, b, c, n=a.size)
  if n == 1
    c << a.pop()
    puts"Moved #{c[-1]} - #{a} #{b} #{c}"
    return
  end
  toh(a, c, b, n-1)
  c << a.pop()
  puts"Moved #{c[-1]} - #{a} #{b} #{c}"
  toh(b, a, c, n-1)
end

a = (1..10).to_a.reverse
b = []
c = []
puts"#{a} #{b} #{c}"
toh(a, b, c)
puts"#{a} #{b} #{c}"
