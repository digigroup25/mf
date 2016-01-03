package collections.tree
{
	import collections.*;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	public dynamic class TreeComposite extends EventDispatcher implements IIterable, ITreeData
	{
		public var vo:*;
		public var children:ArrayCollection;// = new ArrayCollection();
		
		
		/* private function onChildrenChanged(e:CollectionEvent):void
		{
			if (e.kind=="add" || e.kind=="remove")
				this.dispatchEvent(new TreeChildrenChangedEvent());
		} */
		
		public function addChild(child:*):void
		{
			if (children==null)
			{
				children = new ArrayCollection();
				//children.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChanged);
			}
			if (children.getItemIndex(child)!=-1)
				return; //prevent from adding a child twice
			children.addItem(child);
		}
		
		public function addChildren(children:Array):void {
			if (children==null || children.length==0) return;
			for each (var child:* in children) {
				this.addChild(child);
			}
		}
		
		public function addChildAt(child:TreeComposite, index:int):void {
			if (children==null) children=new ArrayCollection();
			if (children.getItemIndex(child)!=-1)
				return; //do not insert if already exists
			children.addItemAt(child, index);
		}
		
		public function setChildAt(child:TreeComposite, index:int):void {
			children.setItemAt(child, index);
		}
		
		public function addChildBefore(child:*, childBefore:*):void
		{
			var i:int = children.getItemIndex(childBefore);
			children.addItemAt(child, i);
		}
		
		public function addChildAfter(child:*, childAfter:*):void
		{
			var i:int = children.getItemIndex(childAfter);
			children.addItemAt(child, i+1);
		}
		
		public function remove(node:TreeComposite, root:TreeComposite):void
		{
			var parent:TreeComposite = node.findParent(root);
			parent.removeChild(node);
			node = null;
		}
		
		public function removeChild(child:TreeComposite):void
		{
			var i:int = children.getItemIndex(child);
			children.removeItemAt(i);
			child = null;
			//if no children make leaf
			//if (children.length==0)
			//	children = null;
		}
		
		public function removeAllChildren():void {
			if (children!=null)
				children.removeAll();
		}
		/**
		 * 
		 * @return copy of children collection
		 * 
		 */		
		public function getChildrenVOs():ArrayCollection
		{
			//clone children
			var clone:ArrayCollection = new ArrayCollection();
			for each(var child:TreeComposite in this.children)
			{
				var newItem:* = child.vo;
				clone.addItem(newItem);
			}
			return clone;
		}
		
		public function getChild(vo:*):TreeComposite
		{
			for each (var child:TreeComposite in this.children)
			{
				if (child.vo==vo)
					return child;
			}
			return null;
		}
		
		public function getChildAt(index:int):TreeComposite {
			if (this.children==null) return null;
			if (index>=this.children.length) return null;
			return this.children[index];
		}

		public virtual function createIterator(type:Class=null):IIterator
		{
			//return new PreOrderTreeIteratorFactory(this, type);
			if (type!=null)
				return new TreeTypeIterator(this, type);
			else
				return new TreeIterator(this);
		}
		
		
		public override function toString():String
		{
			if (vo==null)
				return "";
			else return vo.name;
		}
		
		public function findParent(root:TreeComposite):TreeComposite
		{
			var it:IIterator = root.createIterator();
			while (it.hasNext())
			{
				var curNode:TreeComposite = TreeComposite(it.next());
				for each (var child:TreeComposite in curNode.children)
				{
					if (child==this)
						return curNode;
				}
			}
			return null;
		}
		
		public function find(vo:*, root:TreeComposite):TreeComposite
		{
			var it:IIterator = root.createIterator();
			while (it.hasNext())
			{
				var curNode:TreeComposite = TreeComposite(it.next());
				if (curNode.vo==vo)
					return curNode;
			}
			return null;
		}
		
		public function hasChildren():Boolean {
			return (!isLeaf());
		}
		
		public function isLeaf():Boolean {
			return ((children==null) || (children.length==0));
		}
		
		public function get size():int {
			var res:int = 0;
			var it:IIterator = this.createIterator();
			while (it.hasNext()) {
				res++;
				it.next();
			}
			return res;
		}
		
		//[Bindable("treeChildrenChanged")]
		public function get numChildren():int {
			if (!hasChildren())
				return 0;
			return children.length;
		}
		
		public function getNumLeafs():int
		{
			var res:int = 0;
			
			if (this.isLeaf())
				return 1;
			else 
			{
				for each (var child:TreeComposite in children)
				{
					res += child.getNumLeafs();
				}
			}
			return res;
		}
		
		public function hasChild(child:TreeComposite):Boolean
		{
			for each (var c:TreeComposite in children)
			{
				if (child==c)
					return true;
			}
			return false;
		}
		
		//return path from root (inclusive) to the parent of this (exclusive) 
		public function getPath(root:TreeComposite):Array
		{
			var res:Array = new Array();
			var item:TreeComposite = this;
			while (item.findParent(root)!=null)
			{
				item = item.findParent(root);
				res.push(item);
			}
			return res.reverse();
		}
		
		public function containsChild(child:TreeComposite):Boolean {
			return getChildIndex(child) != -1;
		}
		
		public function getChildIndex(node:TreeComposite):int {
			var res:int = -1;
			var index:int = -1;
			for each (var child:TreeComposite in children) {
				index++;
				if (child==node) {
					res = index;
					break;
				}
			}
			return res;
		}
		
		public function toArray():ArrayCollection {
			return CollectionConverter.toArray(new CollectionConverterContext(this));
		}
		
		public function assignValue(propertyChain:Object, value:Object):void {
			if (propertyChain is String) {
				var propertyChainString:String = String(propertyChain);
				if (!this.hasOwnProperty(propertyChainString))
					throwPropertyDoesNotExist(this, propertyName);
				this[propertyChainString] = value;
				return;
			}
			//assume is array of strings
			var temp:Object = this;
			var propertyChainList:Array = propertyChain as Array;
			
			if (propertyChainList==null || propertyChainList.length==0) {
				throw new Error(StringUtil.substitute("Property chain {0} should have at least 1 element", propertyChainList));
			}
			for  (var i:int=0; i<propertyChainList.length-1; i++) {
				var propertyName:String = propertyChainList[i];
				if (temp.hasOwnProperty(propertyName))
					temp = temp[propertyName];
				else throwPropertyDoesNotExist(temp, propertyName);
			}
			//iterated until last property
			var lastProperty:String = propertyChainList[propertyChainList.length-1];
			temp[lastProperty] = value;
		}
		
		private function throwPropertyDoesNotExist(o:Object, propertyName:String):void {
			throw new Error(StringUtil.substitute("Property {0} does not exist on {1}", propertyName, o));
		}
		
		public function getMaxDepth():int {
			if (!this.hasChildren()) return 0;
			var childrenDepths:Array = new Array();
			for each (var child:TreeComposite in this.children) {
				var childDepth:int = child.getMaxDepth();
				childrenDepths.push(childDepth);
			}
			var maxDepth:int = getMax(childrenDepths);
			return maxDepth+1;
		}
		
		private function getMax(a:Array):int {
			if (a==null || a.length==0) throw new ArgumentError("Array has to contain at least one integer");
			var max:int = a[0];
			for (var i:int = 1; i<a.length; i++) {
				if (a[i]>max) max=a[i];
			}
			
			return max;
		}
		
		public function getLastChildIndex():int {
			if (this.children==null) return -1;
			return this.children.length-1;
		}
		
		public function hasDataOfType(type:Class):Boolean {
			if (this.vo==null && type==null) return true;
			if (this.vo==null || type==null) return false;
			return (this.vo is type);
		}
	}
}