package mindmaps2.elements.task.queries {
	import collections.*;
	import collections.tree.*;

	import mindmaps2.elements.task.operations.TaskService;

	import mx.collections.ArrayCollection;

	public class PrioritizeTasksHierarchicallyQuery implements IQuery {

		public function PrioritizeTasksHierarchicallyQuery(root:TreeCollectionEx, fieldName:String) {
			this.root = root;
			this.fieldName = fieldName;
		}

		private var root:TreeCollectionEx;

		private const sorter:TreeWeightSorter = new TreeWeightSorter();

		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		private const ops:TaskService = new TaskService();

		private var fieldName:String;

		public function execute():ArrayCollection {
			var resTree:TreeCollectionEx = cloner.cloneStructure(root);
			ops.removeDone(resTree);
			ops.removeNonTaskLeafs(resTree);
			var sortedTaskTree:TreeCollectionEx = sorter.sort(resTree, fieldName);

			var res:ArrayCollection = new ArrayCollection();
			res.addItem(sortedTaskTree);
			return res;
		}
	}
}
