package mindmaps.history
{
	import collections.*;
	import collections.tree.*;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	
	import mx.utils.StringUtil;

	public class HistoryController extends AbstractController
	{
		private const history:HistoryManager = new HistoryManager();
		private const treeCloner:TreeCollectionExCloner = new TreeCollectionExCloner();
		private var nodeMessages:NodeMessageFactory;
		private var historyMessages:HistoryMessagesFactory;
		
		private var timer:Timer;
		private var firstAction:Boolean = false;
		private var targetNodeLookup:Dictionary;
		private var target:MapModel2;
		
		public function HistoryController(model:IModelProvider=null, mb:IMessageBroker=null, messageHandler:Function=null)
		{
			super(model, mb, this.messageHandler);
			nodeMessages = new NodeMessageFactory(this);
			historyMessages = new HistoryMessagesFactory(this);
		}
		
		private function messageHandler(m:Message):void {
			switch (m.name) {
				case NodeMessages.ADD_NODE:
				case NodeMessages.REMOVE_NODE:
				case NodeMessages.UPDATE_NODE_DATA:
					onNodeChangedMessage(m); break;
				case HistoryMessages.REPLAY_ALL_ACTIONS:
					onReplayMessage(m); break;
			}
		}
		
		private function onNodeChangedMessage(m:Message):void {
			var a:Action = new Action(Operations.getOperation(m.name), m.body);
			history.save(a);
		}
		
		private function onTimer(event:TimerEvent):void {
			if (history.hasNext()){
				var compositeAction:TreeCollectionEx = history.moveNext();
				replayAction(compositeAction);
			}
			else {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
			} 
		}
		
		private function getReplayMessage(action:Action):Message {
			var newMessage:Message;
			var parentNode:TreeCollectionEx;
			var childNode:TreeCollectionEx;
			
			if (action.operation.name==NodeMessages.ADD_NODE) {
				parentNode = getNode(targetNodeLookup, action.data.location.parentNode);
				node = getNode(targetNodeLookup, action.data.node);
				newMessage = nodeMessages.AddNode(node, new NodeLocation(parentNode, action.data.childNodeIndex));
			}
				
			else if (action.operation.name == NodeMessages.REMOVE_NODE) {
				parentNode = getNode(targetNodeLookup, action.data.location.parentNode);
				node = getNode(targetNodeLookup, action.data.node);
				newMessage = nodeMessages.RemoveNode(node, new NodeLocation(parentNode, action.data.location.childNodeIndex));
			}
			else if (action.operation.name == NodeMessages.UPDATE_NODE_DATA) {
				var node:TreeCollectionEx = getNode(targetNodeLookup, action.data.node);
				var propertyChain:Object = action.data.propertyChain;
				var oldValue:Object = action.data.oldValue;
				var newValue:Object = action.data.newValue;
				newMessage = nodeMessages.UpdateNodeData(node, propertyChain, oldValue, newValue);
			}
			else throw new Error (StringUtil.substitute("Operation {0} is not supported", action.operation.name));
			return newMessage;
		}
		
		private function getReplayMessages(compositeAction:TreeCollectionEx):Array {
			var newMessages:Array = [];
			
			var action:Action = Action(compositeAction.vo);
			if (action!=null) {
				newMessages.push(getReplayMessage(action));
			}
			else {
				var actionIterator:IIterator = compositeAction.createIterator(Action);
				for (; actionIterator.hasNext(); ) {
					var nextAction:Action = Action(actionIterator.next());
					newMessages.push(getReplayMessage(nextAction));
				}
			}
			return newMessages;
		}
		
		private function replayAction(compositeAction:TreeCollectionEx):void {
			var newMessages:Array = getReplayMessages(compositeAction);
			for each (var newMessage:Message in newMessages)
				this.send(newMessage);
			
			this.send(historyMessages.Replayed());
			//set target node to new node
			if (firstAction) {
				var addNodeMessage:Message = Message(newMessages[0]);
				if (addNodeMessage.name!=NodeMessages.ADD_NODE)
					throw new Error("First action should be ADD_NODE vs " + addNodeMessage.name);
				var parentNode:TreeCollectionEx = TreeCollectionEx(addNodeMessage.body.location.parentNode);
				target.nodes = parentNode;
				firstAction = false;
			}
		}
		
		private function replayActions():void {
			while (history.hasNext()) {
				var action:TreeCollectionEx = history.moveNext();
				replayAction(action);
			}
		}
		private function onReplayMessage(m:Message):void {
			target = MapModel2(m.body.target);
			var timeInterval:int = m.body.timeInterval as int;
			
			history.seekStart();
			targetNodeLookup = new Dictionary();
			firstAction = true;
			
			if (timeInterval>0) {
				timer = new Timer(timeInterval);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			}
			else {
				replayActions();
			}
			
		}
		
		private function getNode(table:Dictionary, originalNode:TreeCollectionEx):TreeCollectionEx {
			if (table[originalNode]==null)
				table[originalNode] = originalNode.clone(false);
			return TreeCollectionEx(table[originalNode]);
		}
	}
}