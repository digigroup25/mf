package mindmaps2.elements.node.operations {
	import collections.*;
	import collections.tree.BreadthFirstTreeIterator;
	import collections.tree.ITreeIterator;
	import collections.tree.TreeLeafIterator;
	
	import mindmaps.map.NodeLocation;

	public class NodeService {
		/** Removes nodes that match a certain criteria.
		 *  Method signature of isMatchFunction(node:TreeCollectionEx):Boolean
		 */
		public function remove(root:TreeCollectionEx, isMatchFunction:Function, skipRoot:Boolean = false):uint {
			var result:uint = 0;
			var it:ITreeIterator = new BreadthFirstTreeIterator(root);
			if (skipRoot)
				it.next();
			while (it.hasNext()) {
				var node:TreeCollectionEx = TreeCollectionEx(it.peek());
				if (isMatchFunction(node)) {
					var parent:TreeCollectionEx = TreeCollectionEx(node.findParent(root));
					if (parent != null) {
						parent.removeChild(node);
						result++;
					}
					it.skip();
					continue;
				}
				it.next();
			}
			return result;
		}

		public function addChild(parent:TreeCollectionEx, child:TreeCollectionEx):void {
			parent.addChildAt(child, 0);
		}

		public function addSibling(parent:TreeCollectionEx, sibling:TreeCollectionEx, node:TreeCollectionEx):void {
			if (!parent.hasChild(sibling))
				throw new ArgumentError("Sibling is not a child of the parent node");
			parent.addChildAfter(node, sibling);
		}

		public function removeChild(parent:TreeCollectionEx, child:TreeCollectionEx):void {
			if (!parent.hasChild(child))
				return;
			parent.removeChild(child);
		}
		
		public function getNodeLocation(node:TreeCollectionEx, root:TreeCollectionEx):NodeLocation {
			if (node == null)
				return null;
			
			var parentNode:TreeCollectionEx = TreeCollectionEx(node.findParent(root));
			if (parentNode == null)
				return null;
			var nodeIndex:int = parentNode.getChildIndex(node);
			if (nodeIndex == -1)
				return null;
			var nodeLocation:NodeLocation = new NodeLocation(parentNode, nodeIndex);
			return nodeLocation;
		}
	}
}
