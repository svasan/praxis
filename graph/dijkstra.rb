require_relative 'edge_weighted_digraph'
require_relative '../ds/indexed_priority_queue.rb'

class Dijkstra

  def initialize(ewdgraph, s)
    @pq = IndexedMinPriorityQueue.new(ewdgraph.size())
    @dist_to = Array.new(ewdgraph.size()) {  Float::INFINITY }
    @marked = Array.new(ewdgraph.size())
    @edge_to = Array.new(ewdgraph.size())
    @dist_to[s] = 0

    @pq << [s, 0]

    until @pq.empty?
      v, _ = @pq.pop
      relax(v, ewdgraph.edges(v))
    end
  end

  def path_to(v)
    path = []
    until @edge_to[v].nil?
      path << @edge_to[v]
      v = @edge_to[v].from
    end
    path.reverse!
    dist = path.reduce(0) { |s, e| s += e.weight}
    [path, dist]
  end

  def dist_to(v)
    path_to(v).reduce(0) { |s, e|  s += e.weight}
  end

  private
  def relax(v, edges)
    edges.each do |e|
      if @dist_to[e.to] > @dist_to[e.from] + e.weight
        @dist_to[e.to] = @dist_to[e.from] + e.weight
        @edge_to[e.to] = e
        @pq << [e.to, @dist_to[e.to]]
      end
    end
  end
end

if __FILE__ == $0
  s = ARGV.pop.to_i
  ewd = EdgeWeightedDigraph.fromFile(ARGF)
  d = Dijkstra.new(ewd,s)
  0.upto(ewd.size()-1) do |i|
    path, dist = d.path_to(i)
    puts "#{s} to #{i} (%.2f): #{path}" % dist
  end

end
