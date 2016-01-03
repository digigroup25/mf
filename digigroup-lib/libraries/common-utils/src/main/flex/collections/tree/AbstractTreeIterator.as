package collections.tree
{
	import collections.TreeCollectionEx;
	
	public class AbstractTreeIterator implements ITreeIterator
	{
		protected var itemsToVisit:Array = new Array();
		protected var isReverse:Boolean;
		
		public function AbstractTreeIterator(root:TreeComposite, isReverse:Boolean=false)
		{
			this.isReverse = isReverse;
			itemsToVisit.push(new TreeIteratorItem(root, 0));
		}
		
		public function hasNext():Boolean
		{
			return (itemsToVisit.length>0)
		}
		
		public function next():Object
		{
			//replace first element with its children
			var cur:TreeIteratorItem = removeCurrentIteratorItem();
			var curNode:Object = cur.node;
			
			if (curNode.children==null || curNode.children.length==0)
				return curNode;
				
			
			addChildren(cur);
				
			return curNode;
		}
		
		protected function removeCurrentIteratorItem():TreeIteratorItem {
			return (!isReverse) ? TreeIteratorItem(itemsToVisit.shift()) :
				TreeIteratorItem(itemsToVisit.pop());
		}
		
		public function get currentIteratorItem():TreeIteratorItem {
			return itemsToVisit[0];
		}
		
		protected function addChildren(node:TreeIteratorItem):void {
			throw new Error("abstract method");
		}
		
		public function peek():*
		{
			return itemsToVisit[0].node;
		}
		
		public function skip():*
		{
			var cur:TreeIteratorItem = TreeIteratorItem(itemsToVisit.shift());
			return cur.node;
		}

	}
}