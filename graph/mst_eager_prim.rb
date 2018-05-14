require_relative '../ds/que.rb'
require_relative '../ds/indexed_priority_queue'

class EagerPrimMST

  def initialize(ewgraph)
    @pq = IndexedMinPriorityQueue.new(ewgraph.size())
    vertices = Que.new
    @mst = []
    @dist_to = Array.new(ewgraph.size) { Float::INFINITY }
    @edge_to = Array.new(ewgraph.size)
    @marked = Array.new(ewgraph.size)
    vertices << 0
    @marked[0] = true
    @dist_to[0] = @edge_to[0] = 0
    until vertices.empty?
      v = vertices.pop()
      relax(v, ewgraph.edges(v))
      break if @pq.empty?

      w, e = @pq.pop
      @mst << e
      vertices << w
      @marked[w] = true
    end
  end

  def mst
    @mst
  end

  private
  def relax(v, edges)
    edges.each do |e|
      w = e.other(v)
      next if @marked[w]
      if e.weight() < @dist_to[w]
        @dist_to[w] = e.weight()
        @edge_to[w] = e
        @pq << [w, e]
      end
    end
  end
end

if __FILE__ == $0
  require_relative 'edge_weighted_graph'
  ewg = EdgeWeightedGraph.fromFile(ARGF)
  mst = EagerPrimMST.new(ewg).mst
  puts "#{mst}"
  puts "ewg size: #{ewg.size} vertices, #{ewg.nedges} edges"
  puts "MST has #{ mst.size } edges of weight #{mst.reduce(0) { |sum, e| sum + e.weight()}}"
end
