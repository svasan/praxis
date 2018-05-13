class BreadthFirstPaths

  def initialize(graph, s)
    @graph = graph
    @source = s
    @visited = Array.new(graph.nvertices, false)
    @from = Array.new(graph.nvertices)
    bfs
  end

  def bfs()
    queue = []
    queue.push(@source)
    @visited[@source] = true

    until queue.empty?
      v = queue.shift()
      @graph.each_edge(v) do |w|
        if not @visited[w]
          @from[w] = v
          @visited[w] = true
          queue.push(w)
        end
      end
    end
  end

  def path_to?(v)
    @visited[v]
  end

  def path_to(v)
    return nil if path_to?(v).nil?

    w = v
    path = []
    until w == @source
      path << w
      w = @from[w]
    end
    path << w
    path.reverse
  end
end
