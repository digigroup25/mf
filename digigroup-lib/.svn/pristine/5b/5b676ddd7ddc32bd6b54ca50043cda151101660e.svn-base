package mindmaps2.map.controllers {
	import collections.TreeCollectionEx;

	import factories.TreeFactory;

	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;

	import mindmaps2.elements.ElementConverter;
	import mindmaps2.elements.node.operations.NodeService;

	public class MindMapController extends AbstractController {
		private static const service:NodeService = new NodeService();

		public function MindMapController(model:IModelProvider = null, mb:IMessageBroker = null) {
			super(model, mb);
			messages = new NodeMessageFactory(this);
		}

		private var messages:NodeMessageFactory;

		override public function receive(m:Message):void {
			var parentNode:TreeCollectionEx;
			var childNode:TreeCollectionEx;
			var node:TreeCollectionEx;
			var location:NodeLocation;

			switch (m.name) {
				case NodeMessages.ADD_NEW_NODE_TYPE:
					var nodeType:Class = m.body.nodeType;
					childNode = TreeFactory.createNode(nodeType); // new TreeCollectionEx(item);
					parentNode = TreeCollectionEx(m.body.parentNode);
					var addAs:String = m.body.addAs;
					if (addAs == "sibling") {
						var siblingNode:TreeCollectionEx = TreeCollectionEx(m.body.siblingNode);
						service.addSibling(parentNode, siblingNode, childNode);
					} else {
						service.addChild(parentNode, childNode);
					}
					//know that it is new node (not undo)
					//may need to create new Message type to have reason as a field
					send(messages.AddedNode(childNode, parentNode, { reason: "new" }));
					break;

				case NodeMessages.ADD_NODE:
					node = TreeCollectionEx(m.body.node);
					parentNode = m.body.parentNode;
					var addAs:String = m.body.addAs;
					if (addAs == "location") {
						var location:NodeLocation = m.body.location;
						parentNode = location.parentNode;
						var childNodeIndex:int = location.childNodeIndex;
						parentNode.addChildAt(node, childNodeIndex);
					}
					/*else if (addAs=="sibling") {
						var siblingNode:TreeCollectionEx = TreeCollectionEx(parentNode.getChildAt(location.childNodeIndex));
						service.addSibling(parentNode, siblingNode, node);
					}*/else {
						service.addChild(parentNode, node);
					}
					send(messages.AddedNode(node, parentNode, m.body.token));
					break;

				case NodeMessages.REMOVE_NODE:
					var nodeToRemove:TreeCollectionEx = TreeCollectionEx(m.body.node);
					location = NodeLocation(m.body.location);
					location.parentNode.removeChild(nodeToRemove);
					service.removeChild(location.parentNode, nodeToRemove);
					send(messages.RemovedNode(location));
					break;

				case NodeMessages.UPDATE_NODE_DATA:
					node = TreeCollectionEx(m.body.node);
					var propertyChain:Object = m.body.propertyChain;
					var newValue:Object = m.body.newValue;
					node.assignValue(propertyChain, newValue);
					break;

				case NodeMessages.CONVERT_NODE:
					var toNodeType:Class = m.body.toNodeType;
					node = TreeCollectionEx(m.body.node);
					var newVo:* = ElementConverter.convert(node.vo, toNodeType);
					node.vo = newVo;
					send(messages.ConvertedNode(node));
					break;
			}
		}
	}
}
