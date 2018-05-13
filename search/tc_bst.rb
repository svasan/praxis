require_relative 'bst'
require 'test/unit'

class TestBST < Test::Unit::TestCase

  def setup
    @bst = BST.new
    fname = "bst.simple.input"
    @expected = {}
    File.open(fname,"r") do |lines|
      lines.each do |l|
        fields = l.split(/\s+/)
        key = fields[0].strip.to_i
        value = fields[1].chomp.strip
        @bst.put(key, value)
        @expected[key] = value
      end
      @keys = @expected.keys.sort
    end
  end

  def test_basics
    # puts "#{@bst}"
    assert_equal(@keys.length, @bst.size, "Constructed bst is not of the expected size")
    assert_equal(@keys[0], @bst.min, "Minimum is not #{@keys[0]}")
    assert_equal(@keys[-1], @bst.max, "Maximum is not #{@keys[-1]}")
    i = 0
    @bst.each do |k|
      assert_equal(@keys[i], k, "Key #{i}= #{k} did not match expected #{@keys[i]}")
      i += 1
    end
    assert_equal(@keys, @bst.keys)
    @keys.each do |k|
      assert(@bst.contains?(k), "Key #{k} is not contained in the tree.");
      assert_equal(@expected[k], @bst.get(k), "Values don't match for key #{k}");
    end
  end

  def test_floor
    assert_nil(@bst.floor(@keys[0]-1), "There should be no floor for a key below #{@keys[0]}");
    @keys[0..-1].each do |k|
      test_key = k + 1;
      assert_equal(k, @bst.floor(test_key), "Floor for #{test_key} was not #{k}");
      assert_equal(k, @bst.floor(k), "Key #{k} was not its own floor");
    end
  end

  def test_ceiling
    @keys[0..-1].each do |k|
      test_key = k - 1
      assert_equal(k, @bst.ceiling(test_key), "Ceiling for #{test_key} was not #{k}");
      assert_equal(k, @bst.ceiling(k), "Key #{k} was not its own ceiling");
    end
    assert_nil(@bst.ceiling(@keys[-1]+1), "There should be no floor for a key greater than #{@keys[-1]}")
  end

  def test_delete
    # Expected structure:
    #                    12676
    #        2947                    23067
    #    520    10504          22814       23673
    # 108  -   -     11144  21242   -    -      31747

    # delete  min, max, floor(root), ceiling(root), root, in-between nodes and everything else
    delete_keys = [108, 31747, 11144, 21242, 12676, 2947, 23673, 520, 10504, 22814, 23067]

    assert_equal(@bst.keys, delete_keys.sort, "Update delete key order to match structure of input to make sure corner cases are tested.")
    assert_false(@bst.empty?, "Tree should not be empty.")

    delete_keys.each do |k|
      @bst.delete(k)
      @expected.delete(k)
      expected_keys = @expected.keys.sort
      assert_equal(expected_keys, @bst.keys, "Keys not equal after deleting #{k}")
      assert_equal(expected_keys.size, @bst.size, "BST size is not correct after deleting #{k}.")
    end
    assert(@bst.empty?, "Tree should be empty");
    # puts "#{@bst}"
  end

  def test_succ
    for i in (0..@keys.size-2)
      key = @keys[i]
      succ = @keys[i+1]
      assert_equal(succ, @bst.succ(key), "Expected succ(#{key}) to be #{succ} but got #{@bst.succ(key)}")
    end
  end

  def test_common_ancestor
    # Expected structure:
    #                    12676
    #        2947                    23067
    #    520    10504          22814       23673
    # 108  -   -     11144  21242   -    -      31747
    ancestors = { [108, 11144] => 2947, [520, 10504] => 2947, [21242, 31747] => 23067, [22814, 23673] => 23067,
                  [108, 520] => 2947, [10504, 11144] => 2947, [11144, 21242] => 12676, [108, 31747] => 12676, [108, 12676] => nil}
    ancestors.each do |keys, ancestor|
      assert_equal(ancestor, @bst.ancestor(*keys), "Expected ancestor #{ancestor} for #{keys} but got #{@bst.ancestor(*keys)}")
      assert_equal(ancestor, @bst.ancestor(*(keys.reverse)), "Expected ancestor #{ancestor} for #{keys.reverse} but got #{@bst.ancestor(*(keys.reverse))}")
    end
  end
end
