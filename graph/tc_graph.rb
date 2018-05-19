require_relative 'undirected_graph'
require_relative 'digraph'
require_relative 'depth_first_paths'
require_relative 'depth_first_order'
require_relative 'breadth_first_paths'
require_relative 'directed_cycle'
require_relative 'edge_weighted_digraph'
require_relative 'edge_weighted_graph'
require_relative 'mst_eager_prim'
require_relative 'dag_paths'
require 'test/unit'

class TestUndirectedGraph < Test::Unit::TestCase

  def setup
    @graph = File.open("tinyCG.txt") do |io|
      UndirectedGraph.fromFile(io)
    end
    @digraph = File.open("tinyDG.txt") do |io|
      Digraph.fromFile(io)
    end
    @dag = File.open("tinyDAG.txt") do |io|
      Digraph.fromFile(io)
    end
    @ewg = File.open("tinyEWG.txt") do |io|
      EdgeWeightedGraph.fromFile(io)
    end
    @ewd = File.open("tinyEWD.txt") do |io|
      EdgeWeightedDigraph.fromFile(io)
    end
    @ewdag = File.open("tinyEWDAG.txt") do |io|
      EdgeWeightedDigraph.fromFile(io)
    end
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

  def test_directed_cycle
    dc = DirectedCycle.new(@digraph)
    assert_true(dc.cycle?)
    cycle = [[3,2,3], [3,5,4,2,3], [2,0,5,4,2], [8,6,8], [12,9,10,12]]
    assert_equal(cycle.size, dc.cycle.size, "Did not have #{cycle.size} cycles as expected")
    assert_equal(cycle, dc.cycle, "Cycles did not match")
  end

  def test_depth_first_order
    dfo = DepthFirstOrder.new(@digraph)
    pre = Que.new([0,1,5,4,2,3,6,8,9,10,12,11,7])
    post = Que.new([1,3,2,4,5,0,8,12,10,11,9,6,7])
    reverse_post = Stack.new([7,6,9,11,10,12,8,0,5,4,2,3,1].reverse)
    assert_equal(pre, dfo.pre, "PreOrder didn't match for digraph")
    assert_equal(post, dfo.post, "PostOrder didn't match for digraph")
    assert_equal(reverse_post, dfo.reverse_post,
                 "ReversePost didn't match for digraph")
  end

  def test_weighted_directed_cycle
    dc = DirectedCycle.new(@ewd)
    assert_true(dc.cycle?)
    cycle = [[5,4,5],[7,5,7],[2,7,3,6,2],[6,0,4,5,7,3,6],[6,4,5,7,3,6]]
    assert_equal(cycle.size, dc.cycle.size, "Did not have #{cycle.size} cycles as expected")
    assert_equal(cycle, dc.cycle, "Cycles did not match")
  end

  def test_weighted_depth_first_order
    dfo = DepthFirstOrder.new(@ewd)
    pre = Que.new([0,4,5,7,3,6,2,1])
    post = Que.new([2,6,3,7,1,5,4,0])
    reverse_post = Stack.new([0,4,5,1,7,3,6,2].reverse)
    assert_equal(pre, dfo.pre, "PreOrder didn't match for digraph")
    assert_equal(post, dfo.post, "PostOrder didn't match for digraph")
    assert_equal(reverse_post, dfo.reverse_post,
                 "ReversePost didn't match for digraph")
  end

  EWGEdge = EdgeWeightedGraph::Edge

  def test_prim_eager
    prim = EagerPrimMST.new(@ewg)
    mst = []
    mst << EWGEdge.new(0,7,0.16)
    mst << EWGEdge.new(1,7,0.19)
    mst << EWGEdge.new(0,2,0.26)
    mst << EWGEdge.new(2,3,0.17)
    mst << EWGEdge.new(5,7,0.28)
    mst << EWGEdge.new(4,5,0.35)
    mst << EWGEdge.new(6,2,0.4)
    assert_equal(mst, prim.mst, "MST did not match")
  end

  def test_dag_paths
    shortest_paths = [
      [[5, 4], 0.73],
      [[5], 0.32],
      [[5, 7], 0.62],
      [[5, 1], 0.61],
      [[5], 0.35],
      [[], 0.00],
      [[5, 1, 3], 1.13],
      [[5], 0.28],
    ]
    dag_spath = DAGShortestPath.new(@ewdag, 5)
    shortest_paths.each_with_index do |path_to, v|
      assert_equal(path_to, dag_spath.path_to(v),
                  "Shortest path for #{v} is not equal. Expected: #{path_to}, Actual: #{dag_spath.path_to(v)}")
    end

    longest_paths = [
      [[5, 1, 3, 6, 4], 2.44],
      [[5], 0.32],
      [[5, 1, 3, 6, 4, 7], 2.77],
      [[5, 1], 0.61],
      [[5, 1, 3, 6], 2.06],
      [[], 0.0],
      [[5, 1, 3], 1.13],
      [[5, 1, 3, 6, 4], 2.43],
    ]

    dag_lpath = DAGLongestPath.new(@ewdag, 5)
    longest_paths.each_with_index do |path_to, v|
      assert_equal(path_to, dag_lpath.path_to(v),
                  "Longest path for #{v} is not equal. Expected: #{path_to}, Actual: #{dag_lpath.path_to(v)}")

    end
  end
end
