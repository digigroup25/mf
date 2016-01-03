package mindmaps2.ui
{
	import actions.*;
	
	import collections.IIterator;
	
	import components.InteractiveMenu;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mf.framework.AbstractController;
	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	
	import mindmaps2.ApplicationContainer;
	import mindmaps2.actions.UserActionCollector;
	import mindmaps2.map.ui.MindMapMessages;
	
	import mx.events.MenuEvent;

	public class InteractiveMenuController extends AbstractController
	{
		protected var rootAction:AbstractAction;
		private var executingAction:AbstractUserAction;
		protected var menu:InteractiveMenu;
		private var rootContainer:ApplicationContainer;
		protected const userActions:UserActionCollector = new UserActionCollector();
		
		private var actionEvents:Array = [];
		private var mouseDidNotMoveTimer:Timer;
		private var previousContainerUnderMouse:Container2;
		private var containerForMenu:Container2;
		
		private var lastCursorPosition:Point;
		
		private function get applicationView():DisplayObjectContainer {
			return DisplayObjectContainer(model);
		}
		
		public function InteractiveMenuController(model:IModelProvider, mb:IMessageBroker, rootAction:AbstractAction,
			rootContainer:ApplicationContainer)
		{
			super(model, mb, null);
			this.rootAction = rootAction;
			this.rootContainer = rootContainer;
			this.mouseDidNotMoveTimer = new Timer(1000);
		}
		
		public override function initialize():void {
			super.initialize();
			
			menu = new InteractiveMenu();
			menu.delay = 1000;
			
			menu.addEventListener(MenuEvent.ITEM_CLICK, onMenuClick);
			menu.addEventListener(MenuEvent.MENU_SHOW, onMenuShow);
			
			
			rootContainer.view.addEventListener(MouseEvent.MOUSE_MOVE, onApplicationMouseMove);
			this.mouseDidNotMoveTimer.addEventListener(TimerEvent.TIMER, onMouseDidNotMove);
			applicationView.addChild(menu);
			
			//assume first menu position is in the middle of the screen
			lastCursorPosition = new Point(rootContainer.view.width/2, rootContainer.view.height/2);
			trace("InteractiveMenuController.initialize", lastCursorPosition.x, lastCursorPosition.y);
			
			containerForMenu = getContainerForMenu();
			var it:IIterator = rootAction.createIterator();
			while (it.hasNext()) {
				var action:AbstractAction = AbstractAction(it.next());
				if (action is AbstractIOAction) {
					AbstractIOAction(action).input.invocationContainer = containerForMenu;
				}	
			}
		}
		
		private function onApplicationMouseMove(event:MouseEvent):void {
			this.lastCursorPosition = new Point(event.stageX, event.stageY);
			this.mouseDidNotMoveTimer.reset();
			this.mouseDidNotMoveTimer.start();
		}
		
		private function onMouseDidNotMove(event:TimerEvent):void {
			this.mouseDidNotMoveTimer.stop();
			
			var containerUnderMouse:Container2 = this.getContainerUnderMouseCursor();
			trace("actionableContainer", containerUnderMouse);
				
			previousContainerUnderMouse=containerUnderMouse;
			
			//only show actions for root container
			if (containerUnderMouse!=this.rootContainer) return;
			
			this.showMenu(containerUnderMouse);
		}
		
		public override function receive(m:Message):void {
			switch (m.name) {
				case MindMapMessages.FOCUS_MAP:
				case MindMapMessages.UNFOCUS_MAP:
					onMindMapFocusChange(m);
					break;
				case ApplicationMessages.FOCUS_IN:
					onApplicationFocusIn(m);
					break;
				case "showMenu":
					onShowMenu(m);
					break;
				case "itemClick":
					onItemClick(m);
					break;
			}
		}
		
		private function onMindMapFocusChange(m:Message):void {
			if (m.name==MindMapMessages.FOCUS_MAP) {
				trace("InteractiveMenuController.onFocusChange.menuStop");
				menu.stop();
			} else {
				trace("InteractiveMenuController.onFocusChange.menuStart");
				menu.start();
			}
		}
		
		private function onApplicationFocusIn(m:Message):void {
			menu.start();
		}
		
		private function onShowMenu(m:Message):void {
			var invocationContainer:Container2 = Container2(m.body.container);
			var availableActions:Array = getAvailableUserActions(invocationContainer);
			var menu:Object = m.body.menu;
			menu.dataProvider = availableActions;
		}
		
		private function onItemClick(m:Message):void {
			var container:Container2 = Container2(m.body.container);
			var action:AbstractUserAction = AbstractUserAction(m.body.action);
			executeActionOnContainer(action, container);
		}
		
		private function printMessage(m:Message):void {
			trace("InteractiveMenuController.printMessage", m.toString());
		}
		
		private function executeActionOnContainer(action:AbstractUserAction, container:Container2):void {
			executingAction = action;
			executingAction.input.invocationContainer = container;
			
			executingAction.addEventListener(ActionEvent.STATUS_CHANGE, processActionEvent);
			executingAction.addEventListener(ActionEvent.UNABLE_TO_EXECUTE, processActionEvent);
			executingAction.initialize();
			
			if (executingAction.userInvocationOnly)
				executingAction.userExecute();
			else
				executingAction.execute();
		}
		
		private function onMenuClick(event:MenuEvent):void {
			trace("InteractiveMenuController.onMenuClick", event.item.data);
			menu.pause();
			var actionChosen:AbstractUserAction = AbstractUserAction(event.item.data);
			executeActionOnContainer(actionChosen, containerForMenu);
		}
		
		private function getContainerForMenu():Container2 {
			return getContainerUnderMouseCursor();
		}
		private function getContainerUnderMouseCursor():Container2 {
			trace("InteractiveMenuController.getContainerUnderMouseCursor", this.lastCursorPosition);
			var res:Object = rootContainer.getContainerIntersectingPoint(this.lastCursorPosition);
			return  res!=null ? res.container : rootContainer;
		}
		
		private function onMenuShow(event:MenuEvent):void {
			trace("InteractiveMenuController.onMenuShow");
			this.containerForMenu = this.getContainerForMenu();
			showMenu(containerForMenu);
		}
		
		protected function showMenu(invocationContainer:Container2):void {
			//make sure menu is always in front of the view
			menu.parent.setChildIndex(menu, menu.parent.numChildren-1);
			
			showNewActions(invocationContainer);
		}
		
		private function processActionEvent(event:ActionEvent):void {
			actionEvents.push(event);
			trace("InteractiveMenuController.processActionEvent", event.targetAction);
			if (event.targetAction == executingAction) {
				if (event.targetAction.status==ActionStatus.COMPLETED)
					showNewActions(this.previousContainerUnderMouse);
				else if (event.targetAction.status==ActionStatus.FAILED) {
					showError(event.targetAction);
					showNewActions(this.previousContainerUnderMouse);
				}
			} else if (event.targetAction.status==ActionStatus.FAILED) {
				showError(event.targetAction);
				showNewActions(this.previousContainerUnderMouse);
			} else if (event.type==ActionEvent.UNABLE_TO_EXECUTE) {
				showNewActions(this.previousContainerUnderMouse);
			}
		}
		
		private function showNewActions(invocationContainer:Container2):void {
			if (invocationContainer==this.rootContainer) return;
			
			var availableActions:Array = getAvailableUserActions(invocationContainer);
			
			/* if (availableActions.length==0) {
				availableActions.push(new AbstractUserAction("No actions found"));
			} */
			
			menu.dataProvider = availableActions;
			menu.move(this.lastCursorPosition.x, this.lastCursorPosition.y);
			menu.start();
		}
		
		protected function getAvailableUserActions(invocationContainer:Container2):Array {
			return userActions.getAvailableUserActionsForContainer(rootAction, invocationContainer);
		}
		
		private function showError(action:AbstractAction):void {
			/* Alert.show("Error executing "+action.name, "Error", Alert.OK, null,
				function(event:CloseEvent):void{showNewActions();}); */
		}

	}
}