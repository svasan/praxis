class DepthFirstPaths
  def initialize(graph, s)
    @graph = graph
    @source = s
    @visited = Array.new(graph.nvertices, false)
    @from = Array.new(graph.nvertices)
    dfs(s)
  end

  def dfs(v = @source)
    @visited[v] = true
    for w in @graph.adjacent(v) do
      if !@visited[w]
        @from[w] =v
        dfs(w)
      end
    end
  end

  def path_to?(v)
    @visited[v]
  end

  def path_to(v)
    return nil if not path_to?(v)

    w = v
    path = []
    while w != @source
      path << w
      w = @from[w]
    end
    path << w
    path.reverse
  end
end
