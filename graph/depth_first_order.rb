require_relative '../ds/stack.rb'
require_relative '../ds/que.rb'

class DepthFirstOrder

  attr_reader :pre, :post, :reverse_post

  def initialize(graph)
    @graph = graph
    @marked = Array.new(graph.size)
    @pre = @post = Que.new
    @reverse_post = Stack.new
    graph.each_vertex do |v|
      if not @marked[v]
        dfs(v)
      end
    end
  end

  def dfs(v)
    @pre << v
    @marked[v] = true
    @graph.each_edge(v) do |w|
      dfs(w) if not @marked[w]
    end
    @post << v
    @reverse_post << v
  end

end
