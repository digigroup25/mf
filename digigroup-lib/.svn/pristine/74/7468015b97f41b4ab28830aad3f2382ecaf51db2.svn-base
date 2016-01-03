package collections.tree
{
	/** Breadth-first iterator
	 */
	public class BreadthFirstTreeIterator extends AbstractTreeIterator
	{
		public function BreadthFirstTreeIterator(root:TreeComposite, isReverse:Boolean=false)
		{
			super(root, isReverse);
		}
		
		protected override function addChildren(item:TreeIteratorItem):void {
			var i:int;
			var curNode:TreeComposite = item.node;
			var newIteratorItem:TreeIteratorItem;
			if (!isReverse) {
				for (i=0; i<curNode.children.length; i++) {
					newIteratorItem = new TreeIteratorItem(curNode.children[i], item.depth+1);
					itemsToVisit.push(newIteratorItem);
					
						
				}
			}
			else {
				for (i=curNode.children.length-1; i>=0; i--) {
					newIteratorItem = new TreeIteratorItem(curNode.children[i], item.depth+1);
					itemsToVisit.unshift(newIteratorItem);
				} 
			}
		}
		
	}
}