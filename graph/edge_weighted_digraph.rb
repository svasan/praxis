require 'set'

class EdgeWeightedDigraph

  class Edge
    include Comparable

    attr_accessor :from, :to, :weight
    def initialize(from, to, weight)
      @from = from
      @to = to
      @weight = weight
    end

    def <=>(other)
      @weight <=> other.weight
    end

    def to_s
      "[#{@from}->#{@to} @ %.2f]" % @weight
    end
    alias_method :inspect, :to_s
  end

  def initialize(n)
    @vertices = Array.new(n) { Set.new }
    @nedges = 0
  end

  def size
    @vertices.size
  end

  def add_edge(e)
    @vertices[e.from] << e
    @nedges += 1
  end

  def adjacent(v)
    @vertices[v]
  end
  alias_method :edges, :adjacent

  def each_edge(v)
    @vertices[v].each do |e|
      yield e
    end
  end

  def each_vertex
    0.upto(@vertices.size-1) do |i|
      yield i
    end
  end

  def each_vertex_with_edges
    @vertices.each_with_index do |edges, v|
      yield v, edges
    end
  end

  def to_s
    s = "{"
    each_vertex_with_edges do |v, edges|
      s << "#{v}=>#{edges.to_a}, " if not edges.empty?
    end
    s.chomp!(', ')
    s << "}"
    s
  end

  def self.fromFile(io)
    nv = io.readline.chomp.to_i
    ne = io.readline.chomp.to_i
    ewd = EdgeWeightedDigraph.new(nv)
    1.upto(ne) do
      from, to, weight = io.readline.chomp.split
      ewd.add_edge(Edge.new(from.to_i, to.to_i, weight.to_f))
    end
    ewd
  end
end


if __FILE__ == $0
  ewd = EdgeWeightedDigraph.fromFile(ARGF)
  puts "#{ewd.to_s}"
end
