package collections.tree
{
	import collections.*;
	
	public class TreeWeightRanker implements ITreeRanker
	{
		private var _treeHeight:int;
		private var _maxRank:int = int.MIN_VALUE;
		private var _minRank:int = int.MAX_VALUE;
		
		//modifies the tree by appending ranks to vo's
		public function rank(root:TreeCollectionEx):TreeRankerResult {
			var it:IIterator = root.createIterator();
			if (root.isLeaf()) return new TreeRankerResult(root, 1, 0, 0);
			
			_treeHeight = root.getMaxDepth() + 1;
			
			//rank root as 0 and advance to the first child
			root.vo.rank = 0;
			it.next();
			
			while (it.hasNext()) {
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				if (!canPrioritize(node)) continue;
				
				var rank:int = calculateRankWithPadding2(node, root);
				node.vo.rank = rank;
				updateMinMaxRank(rank);
			}
			
			var res:TreeRankerResult = new TreeRankerResult(root, _treeHeight, _maxRank, _minRank);
			return res;
		}
		
		private function updateMinMaxRank(r:int):void {
			if (r>_maxRank) 
				_maxRank=r; 
			if (r<_minRank) 
				_minRank=r;
		}
		
		/* private function calculateRankWithPadding(node:TreeCollectionEx, root:TreeCollectionEx):int {
			var rank:int = calculateRank(node, root);

			//pad if necessary
			const maxDepth:int = root.getMaxDepth();
			var diff:int = maxDepth - rank.toString().length;
			if (diff>0)
				rank = rank * Math.pow(10, diff);
			return rank;
		}
		
		private function calculateRank(node:TreeCollectionEx, root:TreeCollectionEx):int {
			var path:Array = node.getPath(root);
			var rank:int = 0;
			for each (var pathNode:TreeCollectionEx in path) {
				var pathPriority:int = getPriority(pathNode);
				rank = rank*10+pathPriority;
			}
			rank = rank*10 + getPriority(node);
			return rank;
		}
		 */
		private function calculateRankWithPadding2(node:TreeCollectionEx, root:TreeCollectionEx):int {
			var path:Array = node.getPath(root);
			var rankString:String = "";
			//ignore prioirity of the root
			var i:int;
			for (i=1; i<path.length; i++) {
				var pathNode:TreeCollectionEx = TreeCollectionEx(path[i]);
				var pathPriority:int = getPriority(pathNode);
				rankString += pathPriority;
			}
			rankString += getPriority(node);
			
			//pad if necessary (ignore root level in padding)
			var diff:int = _treeHeight - 1 - rankString.length;
			for (i=0; i<diff; i++) 
				rankString += "0";
			
			var rank:int = parseInt(rankString);
			return rank;
		}
		
		private function canPrioritize(node:TreeCollectionEx):Boolean { 
			return node.vo.hasOwnProperty("priority");
		}
		private function getPriority(node:TreeCollectionEx):int {
			return canPrioritize(node) ? node.vo.priority : 0;
		}
	}
}