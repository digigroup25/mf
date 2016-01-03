package collections.tree
{
	import classes.TreeFactory;

	import collections.TreeCollectionEx;
	
	import org.flexunit.asserts.assertEquals;


	public class TreeWeightRankerTest
	{
		private const ranker:TreeWeightRanker = new TreeWeightRanker();
		private const trees:TreeFactory = new TreeFactory();
		

		[Test]
		public function test_rank_priorityTaskTree():void {
			var t:TreeCollectionEx = trees.createPriorityTaskTree();
			t.vo.priority = 1;
			var rankedTree:TreeCollectionEx = ranker.rank(t).rankedTree;
			
			assertEquals("root should always be ranked as 0", 0, rankedTree.vo.rank);
			assertEquals(10, rankedTree.children[0].vo.rank);
			assertEquals(12, rankedTree.children[0].children[0].vo.rank);
			assertEquals(13, rankedTree.children[0].children[1].vo.rank);
			assertEquals(20, rankedTree.children[1].vo.rank);
			assertEquals(21, rankedTree.children[1].children[0].vo.rank);
		}

		[Test]
		public function test_rank_priorityTaskTree2():void {
			var t:TreeCollectionEx = trees.createPriorityTaskTree2();
			var rankedTree:TreeCollectionEx = ranker.rank(t).rankedTree;
			
			assertEquals(0, rankedTree.vo.rank);
			assertEquals(100, rankedTree.children[0].vo.rank);
			assertEquals(120, rankedTree.children[0].children[0].vo.rank);
			assertEquals(130, rankedTree.children[0].children[1].vo.rank);
			assertEquals(131, rankedTree.children[0].children[1].children[0].vo.rank);
			assertEquals(132, rankedTree.children[0].children[1].children[1].vo.rank);
			assertEquals(200, rankedTree.children[1].vo.rank);
			assertEquals(210, rankedTree.children[1].children[0].vo.rank);
			assertEquals(220, rankedTree.children[1].children[1].vo.rank);
		}

		[Test]
		public function test_rank_parentChildHPTaskTree():void {
			var t:TreeCollectionEx = trees.createParentChildHPTaskTree();
			var rankedTree:TreeCollectionEx = ranker.rank(t).rankedTree;
			
			assertEquals(0, rankedTree.vo.rank);
			assertEquals(0, rankedTree.children[0].vo.rank);
			assertEquals(2, rankedTree.children[0].children[0].vo.rank);
			assertEquals(3, rankedTree.children[0].children[1].vo.rank);
			assertEquals(10, rankedTree.children[1].vo.rank);
		}
	}
}