package collections {

	import collections.tree.TreeCollectionExCloner;
	import collections.tree.TreeComposite;

	import flash.net.registerClassAlias;
	registerClassAlias("collections.TreeCollectionEx", TreeCollectionEx)

	public dynamic class TreeCollectionEx extends TreeComposite implements ICollection //, IName
	{
		//public var id:String;

		public function TreeCollectionEx(vo:* = null, ignoreCounter:Boolean = false) {
			this.vo = vo;
			//id = UIDUtil.createUID();
		}

		public var id:int;

		/* public function set name (val:String):void {
			vo.name = val;
		}
		public function get name ():String {
			 return vo.name;
		} */

		public function addCollectionItem(item:*):* {
			//add as vo if not TreeComposite
			if (!(item is TreeCollectionEx)) {
				var res:TreeCollectionEx = new TreeCollectionEx();
				res.vo = item;
				item = res;
			}
			this.addChild(item);
			return item;
		}

		public function removeCollectionItem(item:*):void {
			super.remove(item, this);
		}

		public function findByVO(vo:*):* {
			return super.find(vo, this);
		}

		public function findById(nodeId:int):TreeCollectionEx {
			var it:IIterator = this.createIterator();
			while (it.hasNext()) {
				var curNode:TreeCollectionEx = TreeCollectionEx(it.next());
				if (curNode.id == nodeId)
					return curNode;
			}
			return null;
		}

		public function clone(includeChildren:Boolean = true):Object {
			var cloner:TreeCollectionExCloner = new TreeCollectionExCloner();
			return cloner.clone(this, includeChildren);
		}
	}
}