package  mindmaps2.elements.task.queries
{
	import collections.*;
	import collections.tree.*;
	
	import mindmaps2.elements.task.filters.*;
	
	import mx.collections.*;
	
	[Deprecated]
	internal class PrioritizeLeafTasksHierarchicallyQuery implements IQuery
	{
		private var root:TreeCollectionEx;
		
		public function PrioritizeLeafTasksHierarchicallyQuery(root:TreeCollectionEx) {
			this.root = root;
		}
		/**
		 * for every node
			 * compute path 
			 * get raw priority
			 * //remove 0's
			 * get longest and append 0's to others to match the length
			 * assign rank and sort by it
		 * 
		 * @param root
		 * @return 
		 * 
		 */		
		public function execute():ArrayCollection
		{
			//var cloneRoot:TreeCollectionEx = root.clone();
			//remove done
			var it:ITreeIterator = ITreeIterator(/*cloneR*/root.createIterator());
			var filterContext:TaskFilterContext = new TaskFilterContext(true, false, true);
			var res:ArrayCollection = new TaskFilter(it, filterContext).filter();
			
			//compute path
			var resIt:IIterator = new ArrayCollectionIterator(res);
			var context:CollectionConverterContext = new CollectionConverterContext(root, resIt, true);
			res = CollectionConverter.toArray(context);
			
			res = removeNonPriorityItems(res);
			
			for each (var item:TreeCollectionEx in res)
			{
				//add priorities
				addPriorities(item);
				//remove zeros
				//item.vo.rawPriority = removeZeros(item.vo.rawPriority);
			}	
			
			var length:int = getLongestRawPriority(res);
			addTrailingZerosAndCopyRank(res, length);
			res = rank(res);
			
			//remove non-leafs
			var finRes:ArrayCollection = new ArrayCollection();
			for (var i:int=0; i<res.length; i++)
			{
				if (!res[i].hasChildren())
				{
					//res.removeItemAt(i);
					//i--;
					finRes.addItem(res[i]);
				}
			}
			return finRes;
		}
		
		public function addTrailingZerosAndCopyRank(res:ArrayCollection, length:int):void
		{
			for each (var item:* in res)
			{
				//add trailing zeros
				addTrailingZero(item, length);
				item.vo.rank = item.vo.rawPriority;
				delete item.vo.rawPriority;
			}
		}
		
		public function removeNonPriorityItems(col:ArrayCollection):ArrayCollection
		{
			for (var i:int=0; i<col.length; i++)
			{
				var vo:* = col[i].vo;
				if (!vo.hasOwnProperty("priority"))
				{
					col.removeItemAt(i);
					i--;
				}
			}
			return col;
		}
		
		/**
		 * walks through the path and adds priorities to priority property 
		 * @param node
		 * Ex. rawPriority = "104"
		 */		
		public function addPriorities(node:TreeCollectionEx):void
		{
			
			if (!node.vo.hasOwnProperty("priority"))
				return;
			node.vo.rawPriority = "";
			for each (var pathNode:TreeCollectionEx in node.path)
			{
				if (pathNode.vo.hasOwnProperty("priority"))
					node.vo.rawPriority += pathNode.vo.priority;
			}
			node.vo.rawPriority += node.vo.priority;
		}
		
		public function removeZeros(val:String):String
		{
			var pattern:RegExp = /0/g;
			var res:String = val.replace(pattern, "");
			return res;
		}
		
		public function getLongestRawPriority(col:ArrayCollection):int
		{
			var max:int = -1;
			for each (var item:TreeCollectionEx in col)
			{
				if (max<item.vo.rawPriority.length) 
					max=item.vo.rawPriority.length;
			}
			return max;
		}
		
		public function addTrailingZero(node:TreeCollectionEx, length:int):void
		{
			var curLength:int = node.vo.rawPriority.length;
			if (curLength<length) 
				node.vo.rawPriority += createZeros(length-curLength);
		}
		
		private function createZeros(length:int):String
		{
			var res:String = "";
			for (var i:int=0; i<length; i++)
				res+="0";
			return res;
		}
		
		public function rank(col:ArrayCollection):ArrayCollection
		{
			var acv:ArrayCollectionViewer = new ArrayCollectionViewer();
			var context:ArrayCollectionViewerContext = new ArrayCollectionViewerContext("rank", true);
			var res:ArrayCollection = acv.createView(col, context);
			return res;
			
		}
		
	}
}