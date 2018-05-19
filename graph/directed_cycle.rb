require_relative '../ds/stack'

class DirectedCycle
  def initialize(graph)
    @graph = graph
    @marked = Array.new(graph.size)
    @on_stack = Array.new(graph.size)
    @edge_to = Array.new(graph.size)
    @cycle = []
    @graph.each_vertex do |v|
      if not @marked[v]
        @edge_to[v] = v
        dfs(v)
      end
    end
  end

  def dfs(v)
    @marked[v] = true
    @on_stack << v
    @graph.each_edge(v) do |w|
      w = w.to if w.respond_to?(:to)
      if not @marked[w]
        @edge_to[w] = v
        dfs(w)
      elsif @on_stack.include?(w)
        cycle = Stack.new
        n = v
        until n == w
          cycle << n
          n = @edge_to[n]
        end
        cycle << w
        cycle << v
        @cycle << cycle.to_a
      end
    end
    @on_stack.pop
  end

  def cycle?
    not @cycle.empty?
  end

  def cycle
    @cycle
  end
end

if __FILE__ == $0
  require_relative 'digraph'
  g = Digraph.fromFile(ARGF)
  dc = DirectedCycle.new(g)
  if dc.cycle?
    puts "Graph has #{dc.cycle.size} cycle(s): #{dc.cycle}"
  else
    puts "Graph does not have a cycle"
  end
end
