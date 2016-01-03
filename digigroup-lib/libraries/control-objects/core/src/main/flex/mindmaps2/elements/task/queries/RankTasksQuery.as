package mindmaps2.elements.task.queries {
	import collections.TreeCollectionEx;
	import collections.tree.TreeCollectionExCloner;
	import collections.tree.TreeRankerResult;

	import mx.collections.ArrayCollection;

	public class RankTasksQuery implements IQuery {

		public function RankTasksQuery(root:TreeCollectionEx) {
			this.root = root;
		}

		private var root:TreeCollectionEx;

		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		/**
		 * returns TreeRankerResult
		 **/
		public function execute():ArrayCollection {
			var resTree:TreeCollectionEx = TreeCollectionEx(new PrioritizeTasksHierarchicallyQuery(root, "priority").execute()[0]);
			var rankedTree:TreeRankerResult = new RankTasks().rank(resTree);
			var res:ArrayCollection = new ArrayCollection();
			res.addItem(rankedTree);
			return res;
		}
	}
}
