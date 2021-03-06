package mindmaps2.elements.task.queries
{
	import collections.*;
	import collections.tree.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import vos.Task;

	[Deprecated]
	internal class PrioritizeLeafTasksHierarchicallyQuery3 implements IQuery
	{
		private var root:TreeCollectionEx;
		private const ranker:ITreeRanker = new RankTasks();
		private const weightPropertyName:String = "rank";
		
		public function PrioritizeLeafTasksHierarchicallyQuery3(root:TreeCollectionEx)
		{
			this.root = root;
		}

		public function execute():ArrayCollection
		{
			var rankedTree:TreeCollectionEx = ranker.rank(root).rankedTree;
			var it:IIterator = rankedTree.createIterator(Task);
			var res:ArrayCollection = new ArrayCollection();
			
			//aggregate tasks that are not done and are leafs
			while (it.hasNext()) {
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				//add only leaf tasks that are not done
				if (node.isLeaf() && node.vo.done!=1) {
					res.addItem(node);
				}
			}
			
			//sort by rank in descending order
			const sort:Sort = new Sort();
			sort.compareFunction = intSort;
			res.sort = sort;
			res.refresh();
			
			return res;
		}
		
		private function intSort(a:Object, b:Object, fields:Array = null):int {
			var aPriority:int = a.vo.hasOwnProperty(this.weightPropertyName) ? a.vo[weightPropertyName] : int.MIN_VALUE;
			var bPriority:int = b.vo.hasOwnProperty(this.weightPropertyName) ? b.vo[weightPropertyName] : int.MIN_VALUE;
			var res:int;
			if (aPriority==bPriority) res = 0;
			else if (aPriority<bPriority) res = -1;
			else res = 1;
			return -res;
		}
	}
}