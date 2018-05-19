require 'set'

class EdgeWeightedGraph

  class Edge
    include Comparable

    def initialize(v, w, wt)
      @v = v
      @w = w
      @weight = wt
    end

    def weight; @weight; end
    def either; @v; end

    def other(v)
      return @w if v == @v
      return @v if v == @w

      raise RuntimeError, "Edge #{v} doesn't match either end - #{@v} or #{@w}"
    end

    def <=>(_other)
      return @weight <=> _other.weight if @weight != _other.weight

      return @v <=> _other.either if @v != _other.either

      return @w <=> _other.other(_other.either)
    end

    def to_s
      "[#{@v}-#{@w} @ #{@weight}]"
    end
    alias_method :inspect, :to_s

  end

  attr_reader :nedges

  def initialize(n)
    @vertices = Array.new(n) {Set.new()}
    @nedges = 0
  end

  def nvertices()
    @vertices.size()
  end

  alias_method :size, :nvertices

  def edges(v)
    @vertices[v]
  end

  def add_edge(e)
    v = e.either(); w = e.other(v);

    @vertices[v] << e
    @vertices[w] << e
    @nedges += 1
  end

  def each_edge(v)
    @vertices[v].each do |edge|
      yield edge
    end
  end

  def each_vertex()
    0.upto(@vertices.size() - 1) do |i|
      yield i
    end
  end

  def each_vertex_with_edges()
    @vertices.each_with_index do |edges, i|
      yield i, edges
    end
  end

  def to_s
    s = "{"
    each_vertex_with_edges do |v, edges|
      s += "#{v}=>#{edges.to_a}, " if not edges.empty?
    end
    s.strip!.chomp!(',')
    s += "}"
    s
  end

  def self.fromFile(io)
    nv = io.readline.to_i
    ne = io.readline.to_i
    g = EdgeWeightedGraph.new(nv)
    1.upto(ne) do
      from, to, weight = io.readline.split
      g.add_edge(Edge.new(from.to_i, to.to_i, weight.to_f))
    end
    g
  end

end


if __FILE__ == $0
  ewg = EdgeWeightedGraph.fromFile(ARGF)
  puts ewg.to_s
end
