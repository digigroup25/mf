package mindmaps2.elements.task.queries {
	import collections.*;
	import collections.tree.*;

	import mindmaps2.elements.task.operations.TaskService;

	import mx.collections.ArrayCollection;

	public class PrioritizeLeafTasksHierarchicallyQuery4 implements IQuery {

		public function PrioritizeLeafTasksHierarchicallyQuery4(root:TreeCollectionEx) {
			this.root = root;
		}

		private var root:TreeCollectionEx;

		private const sorter:TreeWeightSorter = new TreeWeightSorter();

		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		private const ops:TaskService = new TaskService();

		public function execute():ArrayCollection {
			var resTree:TreeCollectionEx = TreeCollectionEx(new PrioritizeTasksHierarchicallyQuery(root, "priority").execute()[0]);
			var rankedTree:TreeRankerResult = new RankTasks().rank(resTree);
			var res:ArrayCollection = new ArrayCollection();
			var it:IIterator = new TreeLeafIterator(rankedTree.rankedTree);
			while (it.hasNext()) {
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				res.addItem(node);
			}

			return res;
		}
	}
}
