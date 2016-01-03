package mindmaps.statistics
{
	import collections.TreeCollectionEx;
	
	public class StatisticsAnalyzer
	{
		public function StatisticsAnalyzer()
		{
		}
		
		public function analyze(tree:TreeCollectionEx):Statistics {
			var numberOfNodes:int = tree.size;
			var res:Statistics = new Statistics(numberOfNodes);
			
			return res;
		}
	}
}