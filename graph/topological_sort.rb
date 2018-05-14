require_relative 'directed_cycle'
require_relative 'depth_first_order'

class TopologicalSort
  attr_reader :sorted

  def initialize(graph)
    @dc = DirectedCycle.new(graph)
    if not @dc.cycle?
      @sorted = DepthFirstOrder.new(graph).reverse_post
    end
  end

  def dag?
    not cycle?
  end

  def cycle?
    @dc.cycle?
  end

  def cycle
    @dc.cycle
  end
end

if __FILE__ == $0
  require_relative 'digraph'
  graph = Digraph.fromFile(ARGV[0])
  tsort = TopologicalSort.new(graph)

  puts("Topological Sort: #{tsort.sorted}") || exit if not tsort.cycle?

  puts "Graph is not a DAG"
  puts "Cycle: #{tsort.cycle}"
end
