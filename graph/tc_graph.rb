require_relative 'undirected_graph'
require_relative 'depth_first_paths'
require_relative 'breadth_first_paths'
require 'test/unit'

class TestUndirectedGraph < Test::Unit::TestCase

  def setup
    @graph = UndirectedGraph.fromFile("tinyCG.txt")
  end

  def test_dfs_path
    puts "DFS for graph : #{@graph}"
    paths = DepthFirstPaths.new(@graph, 0)
    @graph.each_vertex do |i|
      puts "0 to #{i} : #{paths.path_to(i).join('-')}"
    end
  end

  def test_shortest_path
    puts "BFS for graph : #{@graph}"
    paths = BreadthFirstPaths.new(@graph, 0)
    @graph.each_vertex do |i|
      path = paths.path_to(i)
      puts "0 to #{i} : #{path.join('-')}"
    end
  end

end
