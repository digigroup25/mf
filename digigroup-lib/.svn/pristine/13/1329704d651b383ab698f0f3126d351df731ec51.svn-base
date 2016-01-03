package mindmaps2.actions.menus {
	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.AbstractUserAction;
	import actions.ActionEvent;

	import collections.TreeCollectionEx;

	import commonutils.ClassInspector;

	import components.InteractiveMenu;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.TimerEvent;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;

	import mf.framework.ActionContainerDecorator;
	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.Message;

	import mindmaps.map.MapContext;

	import mx.controls.MenuBar;
	import mx.events.MenuEvent;

	public class MenuContainer extends ActionContainerDecorator // Container2
	{
		private static const ci:ClassInspector = new ClassInspector();

		public function MenuContainer(model:MapContext, parent:DisplayObjectContainer,
			mb:IMessageBroker, voContextMenuContainer:InteractiveObject,
			menuParentContainer:DisplayObjectContainer) {
			var container:Container2 = new Container2(mb, model, null, handleMessage);
			//super(mb, model);
			super(container);
			this.parent = parent;
			this.voContextMenuContainer = voContextMenuContainer;
			this.menuParentContainer = menuParentContainer;
		}

		protected var parent:DisplayObjectContainer;

		protected var view:DisplayObject;

		private var voContextMenuContainer:InteractiveObject;

		private var menuParentContainer:DisplayObjectContainer;

		private var labelActionMap:Object = new Object();

		private var contextMenu:ContextMenu;


		private var elementActions:AbstractAction;

		private var node:TreeCollectionEx; //current node

		private var interactiveMenu:InteractiveMenu;

		private var categoriesMap:Object = { map: "Map" }; //hold modelName to Category pairs, e.g. "map", "Map"

		private var initializationTimer:Timer = new Timer(100);

		private var executingAction:AbstractUserAction;

		/* private function onCreateMenu(m:Message):void {
			invalidateActions();
		} */

		public function invalidateActions():void {
			var availableActions:Array = this.getAvailableActions();

			var menuItems:Array = createAllMenuItems(availableActions);
			thisView.dataProvider = menuItems;
		}

		protected function get mapContext():MapContext {
			return MapContext(model);
		}

		protected function get thisView():MenuBar {
			return MenuBar(view);
		}

		protected function set thisView(val:MenuBar):void {
			view = val;
		}

		override protected function doInitialize():void {
			super.doInitialize();

			thisView = new MenuBar();
			parent.addChild(thisView);
			thisView.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);

			//hack, force menu to update after initialization since action's model input is 
			//set once actions are completed which happens after this container is initialized
			initializationTimer.addEventListener(TimerEvent.TIMER, onInitializationTimerComplete, false, 0, true);
			initializationTimer.start();
		}


		private function onInitializationTimerComplete(event:TimerEvent):void {
			initializationTimer.stop();
			this.invalidateActions();
		}

		private function onItemClick(e:MenuEvent):void {
			executingAction = AbstractUserAction(e.item.action);

			executingAction.addEventListener(ActionEvent.STATUS_CHANGE, onExecutingActionStatusChange);
			executingAction.userExecute();

			invalidateActions();
		}

		private function onExecutingActionStatusChange(event:ActionEvent):void {
			if (event.targetAction != executingAction)
				return;

			invalidateActions();
		}

		private function handleMessage(m:Message):void {
			switch (m.name) {
				case "newElementActions":
					onNewElementActions(m);
					break;
			}
		}

		private function getAvailableActions():Array {
			var res:Array = [];
			for each (var action:AbstractAction in this.actions) {
				res = res.concat(action.getAvailableActions(AbstractUserAction));
			}
			return res;
		}

		private function createAllMenuItems(actions:Array):Array {
			var res:Array = [];
			for (var modelName:String in categoriesMap) {
				var actionsPerModel:Array = getActionsPerInputName(actions, modelName);
				var menuItemsPerCategory:Array = createMenuItemsFor(actionsPerModel, this.categoriesMap[modelName]);
				res = res.concat(menuItemsPerCategory);
			}
			return res;
		}

		private function getActionsPerInputName(actions:Array, name:String):Array {
			var res:Array = [];
			for each (var action:AbstractAction in actions) {
				if (action is AbstractIOAction) {
					var ioAction:AbstractIOAction = AbstractIOAction(action);
					if (ioAction.hasInputForKey(name))
						res.push(ioAction);
				}
			}
			return res;
		}

		private function createMenuItemsFor(actions:Array, menuLabel:String):Array {
			var actionsForMenu:Array = wrapActionsForMenu(actions);
			var menuItems:Array = [{ label: menuLabel, children: actionsForMenu }];
			return menuItems;
		}

		private function wrapActionsForMenu(actions:Array):Array {
			var res:Array = [];
			for each (var action:AbstractAction in actions) {
				res.push({ label: action.label, action: action });
			}
			return res;
		}

		private function onNewElementActions(m:Message):void {
			var action:AbstractAction = AbstractAction(m.body.action);

			//remove previous action if existed
			if (elementActions != null) {
				this.deleteAction(node);

				//remove mapping from node to element name
				delete this.categoriesMap["node"];
			}

			elementActions = action;
			node = TreeCollectionEx(m.body.node);
			setAction(node, elementActions);

			//add mapping from node to element name
			var elementName:String = ci.getClassName(node.vo, true);
			this.categoriesMap["node"] = elementName;
			invalidateActions();
		}
	}
}
