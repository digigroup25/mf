package collections
{
	import mx.collections.ArrayCollection;
	
	public class CollectionConverter
	{
		public static function toArray(context:CollectionConverterContext):ArrayCollection
		{
			var it:IIterator = context.iterator;
			if (it==null)
				it = context.root.createIterator();
			var res:ArrayCollection = new ArrayCollection();
			while (it.hasNext())
				res.addItem(it.next());
			//construct path
			if (context.addPath)
			{
				for each (var item:* in res)
				{
					item.path = item.getPath(context.root);
				}
			}
			return res;
		}
				
		/*
		public static function toArray(root:TreeComposite, breadthFirst:Boolean=true):ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection();
			if (breadthFirst)
			{
				res.addItem(root.vo)
				recurseBreadthFirst(root, res);
			}
			else
				recurseDepthFirst(root, res);
			return res;
		}
		
		public static function recurseDepthFirst(treeNode:TreeComposite, res:ArrayCollection):void
		{
			res.addItem(treeNode.vo);
			for each (var childNode:TreeComposite in treeNode.children)
				recurseDepthFirst(childNode, res);
		}
		
		public static function recurseBreadthFirst(treeNode:TreeComposite, res:ArrayCollection):void
		{
			for each (var childNode:TreeComposite in treeNode.children)
				res.addItem(childNode.vo);
			for each (childNode in treeNode.children)
				recurseBreadthFirst(childNode, res);
		}
		*/
	}
}