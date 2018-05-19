require 'set'

class UndirectedGraph
  attr_reader :nedges

  def initialize(n)
    @vertices = Array.new(n) {Set.new()}
    @nedges = 0
  end

  def nvertices()
    @vertices.size()
  end

  alias_method :size, :nvertices

  def adjacent(v)
    @vertices[v]
  end

  def add_edge(from, to)
    @vertices[from] << to
    @vertices[to] << from
    @nedges += 1
  end

  def each_edge(v)
    @vertices[v].each do |to|
      yield to
    end
  end

  def each_vertex()
    0.upto(@vertices.size() - 1) do |i|
      yield i
    end
  end

  def each_vertex_with_edges()
    @vertices.each_with_index do |adj, i|
      yield i, adj
    end
  end

  def to_s
    s = "["
    each_vertex_with_edges do |v, adj|
      s += "{#{v} : #{adj.to_a}}, " if not adj.empty?
    end
    s += "]"
    s
  end

  def self.fromFile(io)
    nv = io.readline.to_i
    ne = io.readline.to_i
    g = UndirectedGraph.new(nv)
    1.upto(ne) do
      from, to = io.readline.split
      g.add_edge(from.to_i, to.to_i)
    end
    g
  end

end


if __FILE__ == $0
  g = UndirectedGraph.fromFile(ARGV[0])
  puts g.to_s
end
