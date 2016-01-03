package collections.tree
{
	import collections.*;
	
	public class SubtreeIterator implements IIterator
	{
		private var it:IIterator;
		public function SubtreeIterator(root:TreeCollectionEx)
		{
			it = root.createIterator();
			it.next();//skip root
		}
		
		public function hasNext():Boolean
		{
			return it.hasNext();
		}
		
		public function next():Object
		{
			return it.next();
		}
	}
}