class ConnectedComponents

  def initialize(graph)
    @graph = graph
    @component_id = Array.new(@graph.size)
    @marked = Array.new(@graph.size)
    @component = 0
    @graph.each_vertex do |v|
      if not @marked[v]
        dfs(v, @component)
        @component += 1
      end
    end
  end

  def dfs(v, cid)
    @marked[v] = true
    @component_id[v] = cid
    @graph.each_edge(v) do |w|
      if not @marked[w]
        dfs(w, cid)
      end
    end
  end

  def connected(v, w)
    @component_id[v] == @component_id[w]
  end

  # Number of connected components
  def size
    @component
  end
end
