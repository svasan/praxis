require_relative 'depth_first_order'

class StronglyConnectedComponents

  def initialize(graph)
    @graph = graph
    @component_id = Array.new(@graph.size)
    @marked = Array.new(@graph.size)
    @components = []
    cid = 0
    reverse_post = DepthFirstOrder.new(graph.reverse).reverse_post
    reverse_post.each do |v|
      if not @marked[v]
        @components[cid] = []
        dfs(v, cid)
        cid += 1
      end
    end
  end

  def dfs(v, cid)
    @marked[v] = true
    @component_id[v] = cid
    @components[cid] << v
    @graph.each_edge(v) do |w|
      if not @marked[w]
        dfs(w, cid)
      end
    end
  end

  def connected?(v, w)
    @component_id[v] == @component_id[w]
  end

  # Number of connected components
  def size
    @components.size
  end

  def components
    @components
  end
end


if __FILE__ == $0
  require_relative 'digraph'
  g = Digraph.fromFile(ARGV[0])
  scc = StronglyConnectedComponents.new(g)
  if scc.size > 0
    puts "Graph has #{scc.size} strongly connected components: #{scc.components}"
  else
    puts "Graph has no strongly connected components"
  end
end
