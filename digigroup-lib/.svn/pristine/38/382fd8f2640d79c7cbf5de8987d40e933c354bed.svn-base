package mindmaps2.elements.task.queries {
	import collections.*;
	import collections.tree.*;

	import mindmaps2.elements.task.operations.TaskService;

	import mx.collections.ArrayCollection;

	public class PrioritizeTasksHierarchicallyByPriorityAndTimeQuery implements IQuery {

		public function PrioritizeTasksHierarchicallyByPriorityAndTimeQuery(root:TreeCollectionEx) {
			this.root = root;
			this.fieldName = "ptRatio";
		}

		private var root:TreeCollectionEx;

		private const sorter:TreeWeightSorter = new TreeWeightSorter();

		private const cloner:TreeCollectionExCloner = new TreeCollectionExCloner();

		private const ops:TaskService = new TaskService();

		private const calculator:TaskTimeAndPriorityTimeRatioCalculator = new TaskTimeAndPriorityTimeRatioCalculator();

		private var fieldName:String;

		public function execute():ArrayCollection {
			var resTree:TreeCollectionEx = cloner.cloneStructure(root);
			ops.removeDone(resTree);
			ops.removeNonTaskLeafs(resTree);

			//compute non-leaf cumulative times and priority/time ratio (ptRatio)
			//output: tree where each task node has estimatedHours and ptRatio set
			calculator.calculate(resTree);

			//order each level of tree in non-decreasing order based on ptRatio
			var sortedTaskTree:TreeCollectionEx = sorter.sort(resTree, fieldName);

			var res:ArrayCollection = new ArrayCollection();
			res.addItem(sortedTaskTree);
			return res;
		}
	}
}
