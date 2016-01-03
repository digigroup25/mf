package mindmaps.map.messages {
	import collections.TreeCollectionEx;

	import mf.framework.Message;

	import mindmaps.map.NodeLocation;

	public class NodeMessageFactory {

		public function NodeMessageFactory(sender:Object) {
			this.sender = sender;
		}

		protected var sender:Object;

		public function NewNode(nodeType:Class, parentNode:TreeCollectionEx):Message {
			return new Message(NodeMessages.ADD_NEW_NODE_TYPE, sender, { nodeType: nodeType, parentNode: parentNode });
		}

		public function AddNode(node:TreeCollectionEx, nodeLocation:NodeLocation):Message {
			return new Message(NodeMessages.ADD_NODE, sender, { addAs: "location", node: node, location: nodeLocation });
		}

		public function AddChildNode(node:TreeCollectionEx, parentNode:TreeCollectionEx, token:Object = null):Message {
			return new Message(NodeMessages.ADD_NODE, sender, { addAs: "child", node: node, parentNode: parentNode, token: token });
		}

		public function AddChildNodeType(nodeType:Class, parentNode:TreeCollectionEx, token:Object = null):Message {
			return new Message(NodeMessages.ADD_NEW_NODE_TYPE, sender,
				{ addAs: "child", nodeType: nodeType, parentNode: parentNode, token: token });
		}

		public function AddSiblingNodeType(nodeType:Class, parentNode:TreeCollectionEx, siblingNode:TreeCollectionEx, token:Object = null):Message {
			return new Message(NodeMessages.ADD_NEW_NODE_TYPE, sender,
				{ addAs: "sibling", nodeType: nodeType, parentNode: parentNode, siblingNode: siblingNode, token: token });
		}

		public function AddedNode(node:TreeCollectionEx, parentNode:TreeCollectionEx, token:Object = null):Message {
			return new Message(NodeMessages.ADDED_NODE, sender, { node: node, parentNode: parentNode, token: token });
		}

		public function UpdateNodeData(node:TreeCollectionEx, propertyChain:Object, oldValue:Object, newValue:Object):Message {
			return new Message(NodeMessages.UPDATE_NODE_DATA, sender, { node: node, propertyChain: propertyChain,
					oldValue: oldValue, newValue: newValue });
		}

		public function MoveNode(node:TreeCollectionEx, fromLocation:NodeLocation, toLocation:NodeLocation):Message {
			return new Message(NodeMessages.MOVE_NODE, sender, { node: node, oldLocation: fromLocation, newLocation: toLocation });
		}

		public function EditingNode(node:TreeCollectionEx):Message {
			return new Message(NodeMessages.EDITING_NODE, sender, { node: node });
		}

		public function RemoveNode(node:TreeCollectionEx, nodeLocation:NodeLocation):Message {
			return new Message(NodeMessages.REMOVE_NODE, sender, { node: node, location: nodeLocation });
		}

		public function RemovedNode(location:NodeLocation):Message {
			return new Message(NodeMessages.REMOVED_NODE, sender, { location: location });
		}

		public function SelectNode(node:TreeCollectionEx, userSelect:Boolean):Message {
			return new Message(NodeMessages.SELECT_NODE, sender,
				{ focus: true, node: node, userSelect: userSelect });
		}

		public function SelectedNode(node:TreeCollectionEx):Message {
			return new Message(NodeMessages.SELECTED_NODE, sender, node);
		}

		public function SelectData(vo:*):Message {
			return new Message(NodeMessages.SELECT_DATA, sender, { focus: true, data: vo });
		}

		public function ConvertNode(node:TreeCollectionEx, toNodeType:Class):Message {
			return new Message(NodeMessages.CONVERT_NODE, sender, { node: node, toNodeType: toNodeType });
		}

		public function ConvertedNode(node:TreeCollectionEx):Message {
			return new Message(NodeMessages.CONVERTED_NODE, sender, { node: node });
		}

		public function ImportedNode(node:TreeCollectionEx):Message {
			return new Message(NodeMessages.IMPORTED_NODE, sender, { node: node });
		}
	}
}
