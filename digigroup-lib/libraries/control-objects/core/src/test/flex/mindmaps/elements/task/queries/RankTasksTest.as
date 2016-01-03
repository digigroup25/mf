package mindmaps.elements.task.queries
{
	import collections.TreeCollectionEx;
	import collections.tree.*;
	
	import factories.TreeFactory;
	
	import flexunit.framework.TestCase;
	
	import mindmaps2.elements.task.queries.RankTasks;
	import mindmaps2.elements.task.queries.RankTasksQuery;
	
	import org.flexunit.asserts.*;
	
	public class RankTasksTest 
	{
		[Test]
		public function test_rank():void {
			var tree:TreeCollectionEx = new TreeFactory().createPriorityTaskTree();
			tree.children[1].vo.done = 1;
			var ranker:RankTasks = new RankTasks();
			var res:TreeRankerResult = ranker.rank(tree);
			var resTree:TreeCollectionEx = res.rankedTree;
			assertEquals(1, resTree.children.length);
			assertFalse("1B" == resTree.children[0].vo.name);
		}
	}
}