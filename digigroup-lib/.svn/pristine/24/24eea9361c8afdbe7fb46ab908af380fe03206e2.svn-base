package collections.tree
{
	import collections.IIterator;
	
	import mx.collections.ArrayCollection;
	
	public class InOrderTreeIterator implements IIterator
	{
		private var itemsToVisit:Array = new Array();
		private var root:TreeComposite;
		private var res:ArrayCollection;
		
		public function InOrderTreeIterator(root:TreeComposite)
		{
			itemsToVisit.push(root);
			this.root=root;
		}
		
		public function hasNext():Boolean
		{
			return (itemsToVisit.length>0)
		}
		
		public function next():Object
		{
			return itemsToVisit.pop();
		}
		
		public function getPath():Array
		{
			var r:Array = new Array();
			for each(var item:TreeIteratorItem in res)
				r.unshift(item.node);
			return r;
		}
		
		
		public function getArray():ArrayCollection
		{
			res = new ArrayCollection();
			traverse(root);
			return res;
		}
		
		public function traverse(node:TreeComposite):void
		{
			traverseLeftSubTree(node);
			//var midIndex:int = getMidIndex(node.numChildren);
			res.addItem(node);//node.children[midIndex]);
			traverseRightSubTree(node);
		}
		
		public function traverseLeftSubTree(node:TreeComposite):void
		{
			var leftIndex:int = getLeftIndex(node.numChildren);
			for (var i:int=0; i<=leftIndex; i++)
				traverse(node.children[i]);
		}
		
		public function traverseRightSubTree(node:TreeComposite):void
		{
			var rightIndex:int = getRightIndex(node.numChildren);
			for (var i:int=rightIndex; i<node.numChildren; i++)
				traverse(node.children[i]);
		}
		
		public function getLeftIndex(n:int):int
		{	
			var res:int = (n+1)/2;
			return (res-1);
		}
		
		public function getRightIndex(n:int):int
		{
			if (n<=1)
				return int.MAX_VALUE;
			else return (n+1)/2;
		}
		/*
		public function getMidIndex(n:int):int
		{
			if (n%2==0)
				return -1;
			else return n/2;
		}*/
	}
}