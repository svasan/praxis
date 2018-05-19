require_relative './topological_sort'
require_relative './edge_weighted_digraph'

class DAGPaths
  def initialize(ewdag, s)
    @dist_to = Array.new(ewdag.size) {  initial_dist() }
    @edge_to = Array.new(ewdag.size)

    @edge_to[s] = nil
    @dist_to[s] = 0
    tsort = TopologicalSort.new(ewdag)
    raise RuntimeError, "Graph is not a DAG" if not tsort.dag?

    tsort.sorted.each do |v|
      relax(v, ewdag.edges(v))
    end
  end

  def path_to(v)
    path = []
    dist = @dist_to[v]
    until @edge_to[v].nil?
      edge = @edge_to[v]
      path << edge.from
      v = edge.from
    end
    [path.reverse, dist.round(4)]
  end

  def relax(v, edges)
    edges.each do |e|
      if better_path?(e)
        @dist_to[e.to] = @dist_to[e.from] + e.weight
        @edge_to[e.to] = e
      end
    end
  end
end


class DAGShortestPath < DAGPaths
  private
  def initial_dist
    Float::INFINITY
  end

  def better_path?(e)
    @dist_to[e.to] > @dist_to[e.from] + e.weight
  end
end

class DAGLongestPath < DAGPaths
  private
  def initial_dist
    -Float::INFINITY
  end

  def better_path?(e)
    @dist_to[e.to] < @dist_to[e.from] + e.weight
  end
end


if __FILE__ == $0
  s = ARGV.pop.to_i
  ewd = EdgeWeightedDigraph.fromFile(ARGF)
  sp = DAGShortestPath.new(ewd, s)
  puts "Shortest paths:"
  0.upto(ewd.size-1) do |v|
    path, dist = sp.path_to(v)
    puts "\t#{s} to #{v} (#{dist}): #{path}"
  end

  puts "\n\nLongestPaths:"
  lp = DAGLongestPath.new(ewd, s)
  0.upto(ewd.size-1) do |v|
    path, dist = lp.path_to(v)
    puts "\t#{s} to #{v} (#{dist}): #{path}"
  end

end
