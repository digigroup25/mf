package mindmaps.map.ui.tree {
	import actions.AbstractAction;
	import actions.AbstractUserAction;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mf.framework.*;

	import mindmaps.map.MapContext;
	import mindmaps.map.MapModel2;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.TreeContainer2Factory;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.containers.SearchableAndMenuTree;
	import mindmaps.search.SearchMessages;
	import mindmaps.search.ui.SearchWindowController;
	import mindmaps.search.ui.components.SearchBox;

	import mindmaps2.actions.map.SaveMap;
	import mindmaps2.actions.menus.MenuContainer;
	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.storage.MapStorageMessages;

	public class TreeMenuContainer extends ViewContainerDecorator {

		private static const SAVE_DELAY:uint = 30 /*s*/ * 1000;

		public function TreeMenuContainer(mb:IMessageBroker, map:MapModel2, mapContext:MapContext,
			parent:DisplayObjectContainer, label:String, rootAction:AbstractAction) {
			this.map = map;
			this.mapContext = mapContext;
			this.parent = parent;
			this._label = label;
			this.rootAction = rootAction;

			treeMapComponent = new SearchableAndMenuTree();
			treeMapComponent.label = map.name;

			var decorated:Container2 = new Container2(mb, map, null, receiveHandler, null);
			//super(mb, null, treeMapComponent, null, null);
			super(decorated, treeMapComponent);

			treeMessages = new NodeMessageFactory(this);
			this.searchBox = new SearchBox();
		}

		private var parent:DisplayObjectContainer;

		private var treeMessages:NodeMessageFactory;

		private var treeContainer:Container2;

		private var searchBox:SearchBox;

		private var map:MapModel2;

		private var _view:DisplayObject;

		private var treeMapComponent:SearchableAndMenuTree;

		private var mapContext:MapContext;

		private var rootAction:AbstractAction;

		private var _label:String = "";

		private var menuContainer:MenuContainer;

		private var timer:Timer = new Timer(SAVE_DELAY, 1);

		//wrong, should query some other container
		//b/c when the name changes, will have to remember to update this label
		public function get label():String {
			return _label; /*treeContainer.label */
		}

		public function getAvailableActionByType(type:Class):AbstractUserAction {
			var availableActions:Array = this.rootAction.getAvailableActions(AbstractUserAction);
			for each (var action:AbstractUserAction in availableActions) {
				if (action is type) {
					return action;
				}
			}
			return null;
		}


		override protected function doInitialize():void {
			super.doInitialize();

			parent.addChild(treeMapComponent);

			timer.addEventListener(TimerEvent.TIMER, onSaveDelayElapsed);

			menuContainer = new MenuContainer(mapContext,
				treeMapComponent.menuContainer, mb, treeMapComponent.treeContainer, null);
			menuContainer.setAction(map, rootAction);

			treeContainer = TreeContainer2Factory.create(mb, map, treeMapComponent.treeContainer,
				label, mapContext);
			treeContainer.name = "treeContainer";

			this.addContainer(menuContainer);
			menuContainer.initialize();

			this.addContainer(treeContainer);
			treeContainer.initialize();

			thisView.searchContainer.addChild(searchBox);
			this.addController(new SearchWindowController(thisView)); //add search view controller to display results
			searchBox.addEventListener("search", onSearchClick);
			searchBox.label = "Search Map";
		}

		override protected function doUninitialize():void {
			searchBox.removeEventListener("search", onSearchClick);

			timer.removeEventListener(TimerEvent.TIMER, onSaveDelayElapsed);

			super.doUninitialize();
		}



		private function get thisView():SearchableAndMenuTree {
			return SearchableAndMenuTree(this.view);
		}

		private function onSearchClick(event:Event):void {
			this.send(new Message(SearchMessages.SEARCH, this, { searchValue: searchBox.text, map: map }));
		}

		private function receiveHandler(m:Message):void {
			var newMsg:Message;
			switch (m.name) {
				case NodeMessages.SELECTED_NODE:
					menuContainer.invalidateActions();
					break;

				case MapMessages.NEW:
					newMsg = treeMessages.NewNode(m.body.type, null);
					send(newMsg);
					break;

				case MindMapMessages.CHANGED_MAP:
					updateMapLabelInTab(true);
					triggerDelayedSave();
					break;

				case MapStorageMessages.SAVED_MAP:
					updateMapLabelInTab(false);
					stopDelayedSave();
					break;

				/* case MapStorageMessages.RENAMED_MAP : {
					if (thisView.label==m.body.oldMapName) {
						thisView.label = m.body.map.name;
					}
					break;
				} */
			}

		}

		private function triggerDelayedSave():void {
			timer.reset(); //reset timer to start from the latest invocation
			timer.start();
		}

		private function stopDelayedSave():void {
			timer.reset();
		}

		private function onSaveDelayElapsed(event:TimerEvent):void {
			timer.stop();

			var saveMapAction:AbstractUserAction = this.getAvailableActionByType(SaveMap);
			if (saveMapAction == null)
				return;
			saveMapAction.userExecute();
		}

		private function updateMapLabelInTab(mapChanged:Boolean):void {
			treeMapComponent.label = (mapChanged ? "*" : "") + map.name;
		}
	}
}
