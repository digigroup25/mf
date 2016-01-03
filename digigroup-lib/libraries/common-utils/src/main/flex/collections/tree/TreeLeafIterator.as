package collections.tree
{
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	public class TreeLeafIterator extends AbstractTreeIterator
	{
		public function TreeLeafIterator(root:TreeComposite, isReverse:Boolean=false)
		{
			super(root, isReverse);
			
			//clear and build itemsToVisit
			itemsToVisit = new Array();
			
			var it:IIterator = new TreeIterator(root);
			while (it.hasNext()) {
				var node:TreeCollectionEx = TreeCollectionEx(it.next());
				if (!node.hasChildren()) {
					itemsToVisit.push(node);
				}
			}
		}
		
		public override function hasNext():Boolean {
			return (itemsToVisit.length>0);
		}
		
		public override function next():Object {
			return (!isReverse) ? itemsToVisit.shift() : itemsToVisit.pop();
		}
	}
}