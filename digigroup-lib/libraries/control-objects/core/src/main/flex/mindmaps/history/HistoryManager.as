package mindmaps.history
{
	import collections.TreeCollectionEx;
	
	import mf.framework.IManagedLifecycle;
	
	import mx.collections.ArrayCollection;
	
	public class HistoryManager implements IManagedLifecycle
	{
		//list of TreeCollectionEx containing leafs with actions as vos
		public var actions:ArrayCollection = new ArrayCollection();
		private var operationRepository:OperationRepository = new OperationRepository();
		private var index:int = -1;
		public var reverse:Boolean = false;
		
		public function HistoryManager()
		{
		}
		
		public function initialize():void {
			operationRepository.register(Operations.ADD_NODE, 			Operations.REMOVE_NODE);
			operationRepository.register(Operations.UPDATE_NODE_DATA, 	Operations.UPDATE_NODE_DATA);
			operationRepository.register(Operations.MOVE_NODE,			Operations.MOVE_NODE);
		}
		
		public function uninitialize():void {
			
		}
		
		private function decomposeAction(action:Action):TreeCollectionEx {
			if (action.operation!=Operations.MOVE_NODE)
				return new TreeCollectionEx(action);
			//move node action
			var moveNode:TreeCollectionEx = new TreeCollectionEx();
			moveNode.addChild(new TreeCollectionEx(new Action(Operations.REMOVE_NODE, {oldLocation:action.data.oldLocation})));
			moveNode.addChild(new TreeCollectionEx(new Action(Operations.ADD_NODE, {newLocation:action.data.newLocation})));
			return moveNode;
		}
		
		public function save(action:Action):void {
			//if an action can be decomposed into smaller, do it here
			var actionNode:TreeCollectionEx = decomposeAction(action);
			actions.addItem(actionNode);
		}
		
		public function seekStart():void {
			index = 0;
		}
		
		public function seekEnd():void {
			index = actions.length-1;
		}
		
		public function moveNext():TreeCollectionEx {
			//index++;
			if (!reverse) {
				if (index>=actions.length)
					throw new Error ("No actions at position "+index);
				var actionNode:TreeCollectionEx = TreeCollectionEx(actions.getItemAt(index++));
				return actionNode;
			}
			else
				return movePrevious();
		}
		
		private function movePrevious():TreeCollectionEx {
			if (index<0)
				throw new Error ("No actions at position "+index);
			var actionNode:TreeCollectionEx = TreeCollectionEx(actions.getItemAt(index--));
			var action:Action = Action(actionNode.vo);
			var complementOp:Operation = operationRepository.getComplement(action.operation);
			
			var complementAction:Action;
			
			//switch old/new values
			if (complementOp==Operations.UPDATE_NODE_DATA) {
				var oldValue:Object = action.data.oldValue;
				var newValue:Object = action.data.newValue;
				complementAction = new Action(complementOp, {node:action.data.node, 
					propertyChain:action.data.propertyChain, newValue:oldValue, oldValue:newValue});
			}
			else complementAction = new Action(complementOp, action.data);
			return new TreeCollectionEx(complementAction);
		}
		
		public function hasNext():Boolean {
			if (!reverse)
				return (index<actions.length);
			else return (index>=0);
		}
	}
}