package collections.tree
{
	import collections.TreeCollectionEx;
	
	/** Pre-order depth-first iterator, i.e. Value-Left-Right
	 */
	public class TreeIterator extends AbstractTreeIterator
	{
		public function TreeIterator(root:TreeComposite, isReverse:Boolean=false)
		{
			super(root, isReverse);
		}
				
		protected override function addChildren(item:TreeIteratorItem):void {
			var i:int;
			var curNode:TreeComposite = item.node;
			var newIteratorItem:TreeIteratorItem;
			if (!isReverse) {
				for (i=curNode.children.length-1; i>=0; i--)
				{
					newIteratorItem = new TreeIteratorItem(curNode.children[i], item.depth+1);
					itemsToVisit.unshift(newIteratorItem);
						
				}
			}
			else {
				for (i=0; i<curNode.children.length; i++) {
					newIteratorItem = new TreeIteratorItem(curNode.children[i], item.depth+1);
					itemsToVisit.push(newIteratorItem);
				} 
			}
		}
		
	}
}