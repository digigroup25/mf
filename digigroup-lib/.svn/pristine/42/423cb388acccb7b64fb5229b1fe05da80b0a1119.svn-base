package mindmaps2.elements.task.queries
{
	import collections.TreeCollectionEx;
	import collections.tree.*;
	
	import commonutils.DeepCopy;
	
	import mindmaps2.elements.task.operations.TaskService;
	
	[Deprecated]
	public class RankTasks implements ITreeRanker
	{
		private const ranker:ITreeRanker = new TreeWeightRanker();
		
		//returns a clone of ranked tree where done tasks (including composite)
		//are not included
		public function rank(root:TreeCollectionEx):TreeRankerResult {
			var rootClone:TreeCollectionEx = TreeCollectionEx(DeepCopy.clone(root, false));
			//remove done
			new TaskService().removeDone(rootClone);
			var rankedResult:TreeRankerResult = ranker.rank(rootClone);
			return rankedResult;
		}
	}
}