package collections.tree
{
	import collections.TreeCollectionEx;
	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	
	public class DoubleLinkedTree extends TreeCollectionEx
	{
		private var _parent:DoubleLinkedTree=null;
		
		public function get parent():DoubleLinkedTree {
			return _parent;
		}
		
		protected function setParent(parent:DoubleLinkedTree):void {
			this._parent = parent;
		}
		
		protected function setNoParent():void {
			this._parent = null;
		}
		
		public function DoubleLinkedTree()
		{
		}
		
		override public function addChild(child:*):void {
			if (child==null)
				return;
			assertNodeType(child);
			super.addChild(child);
			child.setParent(this);
		}
		
		protected function assertNodeType(node:Object):void {
			if (!(node is DoubleLinkedTree))
				throw new ArgumentError("Node must be of type DoubleLinkedTree");
		}
		
		public override function addChildAt(child:TreeComposite, index:int):void {
			assertNodeType(child);
			super.addChildAt(child, index);
			DoubleLinkedTree(child).setParent(this);
		}
		
		public override function setChildAt(child:TreeComposite, index:int):void {
			assertNodeType(child);
			children.setItemAt(child, index);
			DoubleLinkedTree(child).setParent(this);
		}
		
		public override function addChildBefore(child:*, childBefore:*):void {
			var i:int = children.getItemIndex(childBefore);
			if (i==-1) //if not found, insert as a first item
				i=0;
			addChildAt(child, i);
		}
		
		public override function addChildAfter(child:*, childAfter:*):void {
			var i:int = children.getItemIndex(childAfter);
			addChildAt(child, i+1);
		}
		
		public override function findParent(root:TreeComposite):TreeComposite {
			return _parent;
		}
		
		public override function remove(node:TreeComposite, root:TreeComposite):void {
			assertNodeType(node);
			var parent:DoubleLinkedTree = DoubleLinkedTree(node).parent;
			if (parent==null)
				throw new IllegalOperationError("This node does not have a parent");
			parent.removeChild(node);
		}
		
		public override function removeChild(child:TreeComposite):void {
			assertNodeType(child);
			if (!this.hasChildren())
				return;
			var i:int = children.getItemIndex(child);
			if (i==-1) return;
			children.removeItemAt(i);
			DoubleLinkedTree(child).setNoParent();
		}
	}
}