package mindmaps2.elements.ui.controllers
{
	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.AbstractUserAction;
	
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	
	import mindmaps.map.messages.NodeMessages;
	
	import mindmaps2.actions.element.ActOnElementOrUnselect;
	import mindmaps2.actions.Actions;
	import mindmaps2.actions.element.SelectAndActOnElement;

	public class NodeActionController extends AbstractController
	{
		private var selectAction:AbstractAction;
		private var prevSelectedNode:TreeCollectionEx;
		private var prevSelectedElementAction:AbstractUserAction;
		
		private var actionNamesToExclude:Array = [Actions.UNSELECT_ELEMENT];
		
		public function NodeActionController(modelProvider:IModelProvider=null, mb:IMessageBroker=null, messageHandler:Function=null)
		{
			super(modelProvider, mb, messageHandler);
			
			selectAction = new SelectAndActOnElement();
		}
		
		override public function initialize():void {
			super.initialize();
			
			selectAction.initialize();
			selectAction.execute();
		}
		
		override public function receive(m:Message):void {
			switch (m.name) {
				case NodeMessages.SELECTED_NODE:
					onSelectedNode(m);
					break;
			}
		}
		
		private function onSelectedNode(m:Message):void {
			//trace("NodeActionController.onSelectedNode");
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var userSelect:Boolean = m.body.userSelect as Boolean;
			if (node==prevSelectedNode && userSelect) return; //if user selected the node twice disregard
			
			if (prevSelectedNode && prevSelectedElementAction) {
				//unselect node
				var unselectAction:AbstractAction = selectAction.getAvailableActionsByName(Actions.UNSELECT_ELEMENT)[0];
				unselectAction.execute();
			}
			
			
			var selectedElementAction:AbstractUserAction = selectAction.getAvailableActionsByName(Actions.SELECT_ELEMENT)[0];
			prevSelectedNode = node;
			prevSelectedElementAction = selectedElementAction;
			
			selectedElementAction.input.node = node;
			selectedElementAction.input.mapContainer = m.body.mapContainer;
			
			selectedElementAction.userExecute();
			//hack, accessing parent
			var it:IIterator = selectedElementAction.parent.createIterator(ActOnElementOrUnselect);
			var elementAction:AbstractIOAction = AbstractIOAction(it.next());
			var availableElementActions:Array = elementAction.getAvailableActions();
			var filteredElementActions:Array = filterOutHiddenActions(availableElementActions);
			
			this.send(new Message("newElementActions", this, {node:node, action:elementAction}));
		}
		
		private function filterOutHiddenActions(actionsToFilter:Array):Array {
			var filterFunction:Function = function (item:*, index:int, array:Array):Boolean {
				if (!(item is AbstractAction)) return false;
				var action:AbstractAction = AbstractAction(item);
				return actionNamesToExclude.indexOf(action.name)==-1;
			}
			return actionsToFilter.filter(filterFunction);
			
		}
	}
}