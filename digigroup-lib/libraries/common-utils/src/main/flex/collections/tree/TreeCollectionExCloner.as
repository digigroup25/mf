package collections.tree {
	import collections.*;

	import commonutils.DeepCopy;

	public class TreeCollectionExCloner {

		public function cloneStructure(source:TreeCollectionEx, copyReferenceToOriginalNode:Boolean = true):TreeCollectionEx {
			var res:TreeCollectionEx = new TreeCollectionEx(source.vo);
			res.originalNode = source; //copy reference to original node
			for each (var child:TreeCollectionEx in source.children)
				res.addChild(this.cloneStructure(child));
			return res;
		}

		public function clone(source:TreeCollectionEx, includeChildren:Boolean = true, registerClassAliases:Boolean = true):TreeCollectionEx {
			if (includeChildren) {
				return TreeCollectionEx(DeepCopy.clone(source, registerClassAliases));
			} else { // just manually clone vo and other attributes without cloning the children
				var cloneVo:* = DeepCopy.clone(source.vo, registerClassAliases);
				var res:TreeCollectionEx = new TreeCollectionEx(cloneVo);
				res.id = source.id;
				return res;
			}
		}
	}
}
