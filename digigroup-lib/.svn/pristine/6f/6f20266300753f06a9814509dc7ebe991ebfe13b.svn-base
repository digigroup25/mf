package mindmaps.inputqueue {
	import collections.TreeCollectionEx;

	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;

	import mindmaps2.elements.ElementFactory;

	import mx.collections.ArrayCollection;

	import vos.Task;

	public class InputQueueController extends AbstractController {
		private static const INPUT_QUEUE_NAME:String = "Inbox";

		private static var nodeMessages:NodeMessageFactory;

		public function InputQueueController(model:IModelProvider = null, mb:IMessageBroker = null, messageHandler:Function = null) {
			super(model, mb, messageHandler);
			nodeMessages = new NodeMessageFactory(this);
		}

		private const elements:ElementFactory = new ElementFactory();

		override public function receive(m:Message):void {
			switch (m.name) {
				case InputQueueMessages.ADD_TO_INPUT_QUEUE:
					onAddToQueue(m);
					break;
			}
		}

		private function get map():MapModel2 {
			return MapModel2(model);
		}

		private function onAddToQueue(m:Message):void {
			var name:String = String(m.body.name);
			var rootChildren:ArrayCollection = map.nodes.children;

			//if root has no children, create empty list
			if (rootChildren == null) {
				rootChildren = new ArrayCollection();
				map.nodes.children = rootChildren;
			}

			var queueNode:TreeCollectionEx = findQueueContainer(rootChildren);
			//if doesn't exist, add new one
			if (queueNode == null) {
				queueNode = elements.createTask(INPUT_QUEUE_NAME);
				rootChildren.addItemAt(queueNode, 0);
			}

			//add inputted text as a task at the end of the queue
			var newTask:Task = new Task();
			newTask.name = name;
			//queueNode.addCollectionItem(newTask);
			this.send(nodeMessages.AddChildNode(new TreeCollectionEx(newTask), queueNode, m.body.token));

			//this.send(new Message(InputQueueMessages.ADDED_TO_INPUT_QUEUE, this, {inputQueue:queueContainer}));
		}

		private function findQueueContainer(elements:ArrayCollection):TreeCollectionEx {
			for each (var element:TreeCollectionEx in elements) {
				if (element.vo.name == INPUT_QUEUE_NAME) {
					return element;
				}
			}
			return null;
		}
	}
}
