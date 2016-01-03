package mindmaps.map.ui.tree {

	import actions.AbstractAction;
	import actions.AbstractUserAction;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import flexlib.events.SuperTabEvent;

	import logging.LogUtil;

	import mf.framework.*;

	import mindmaps.inputqueue.InputQueueMessages;
	import mindmaps.map.MapModel2;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.components.TreeTabNavigator;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;
	import mindmaps.search.SearchContainerFactory;
	import mindmaps.search.SearchMessages;

	import mindmaps2.actions.map.CloseMap;
	import mindmaps2.map.MindMapTreeContainer;
	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.storage.*;

	import mx.core.Container;
	import mx.events.IndexChangedEvent;
	import mx.logging.ILogger;

	/**
	 * Manages containers in tabs
	 * Assumes all containers managed are IViewProvider
	 */
	public class TreeTabContainer extends Container2 {

		private static const logger:ILogger = LogUtil.getLogger(TreeTabContainer);

		public function TreeTabContainer(parent:DisplayObjectContainer, mb:IMessageBroker, rootAction:AbstractAction) {
			var searchService:IContainer = SearchContainerFactory.createService(mb);
			var containers:Array = [ searchService ];
			super(mb, new TreeTabNavigator(), null, null, containers);
			this.parent = parent;
			this.rootAction = rootAction;

			this.messages = new MapStorageMessageFactory(this);
		}

		protected var parent:DisplayObjectContainer;

		private var tabContainers:Array = new Array();

		private var messages:MapStorageMessageFactory;

		private var previousContainer:IContainer;

		private var rootAction:AbstractAction;

		override public function receive(m:Message):void {
			switch (m.name) {
				case TreeTabMessages.OPEN_MAP_IN_TAB:
					openInTab(m);
					break;

				/*case TreeTabMessages.CLOSE_MAP_IN_TAB:
					sendToContainer(MapModel2(m.body.map), m);
					break;*/
				case MindMapMessages.CLOSE_MAP:
					closeTab(m);
					break;
				case MapStorageMessages.SAVED_MAP:
					sendToContainer(MapModel2(m.body.map), m);
					break;
				//VR 6/5/11 caused infinite loop, need to fix so that the new map name is shown in the tab
				/*case MapStorageMessages.RENAMED_MAP:
					mapRenamed(m); break;*/
				case MapStorageMessages.NEWED_MAP:
					onMapNewed(m);
					break;

				case MindMapMessages.EXPORT_MAP_TO_XML:
				case MindMapMessages.EXPORT_MAP_TO_TEXT:
				case MindMapMessages.IMPORT_MAP:
				case MindMapMessages.IMPORTED_MAP:
				case MapMessages.STATISTICS:
				case MapMessages.BRAINSTORM:
				case NodeMessages.EXPAND_DESCENDANTS:
				case InputQueueMessages.SHOW_INPUT_QUEUE:
				case SearchMessages.SEARCH_RESULT:
					sendToContainer(MapModel2(m.body.map), m);
					break;
				case MapMessages.OPEN_MAP_DIRECTORY:
					this.send(new Message(MapMessages.OPEN_MAP_DIRECTORY_IN_TAB, this, { parent: thisView }));
					break;
			}
		}

		protected function get thisView():TreeTabNavigator {
			return TreeTabNavigator(this.model);
		}

		override protected function doInitialize():void {
			super.doInitialize();

			thisView.addEventListener(SuperTabEvent.TAB_CLOSE, closeTabHandler);
			thisView.addEventListener(IndexChangedEvent.CHANGE, tabIndexChangedHandler);

			if (parent != null)
				parent.addChild(thisView);

		/* for each (var map:MapModel2 in thisModel) {
			thisView.callLater(addTab, [map]);
		} */
		}

		override protected function doUninitialize():void {
			thisView.removeEventListener(SuperTabEvent.TAB_CLOSE, closeTabHandler);
			thisView.removeEventListener(IndexChangedEvent.CHANGE, tabIndexChangedHandler);

			while (tabContainers.length > 0) {
				var container:IContainer = IContainer(tabContainers.pop());
				container.uninitialize();
			}
			tabContainers = null;

			if (parent != null)
				parent.removeChild(thisView);
			parent = null;

			super.doUninitialize();
		}

		private function sendToContainer(map:MapModel2, m:Message):void {
			if (map == null)
				return;
			var tabContainerIndex:int = findTabIndexByLabel(map.name);
			if (tabContainerIndex == -1)
				return;
			var tabContainer:IContainer = this.tabContainers[tabContainerIndex];

			//mark as forwarded
			//otherwise stack overflow, b/c internalMessageAdapter thinks it received
			//the message from within which in turn will send it outbound,
			//arrive here and sent back internalMessageAdapter resulting in stack overflow
			m.isForwarded = true;
			m.sender = this; //reset sender to prevent infinite loop
			tabContainer.send(m);
		}

		private function onMapNewed(m:Message):void {
			trace("map newed - treeTabContainer");
			var doNotPersist:Boolean = m.body.token.doNotPersist;
			//if (doNotPersist)
			//this.send(messages.LoadedMap(m.body.map));
			//openInTab(m);
		}

		private function mapRenamed(m:Message):void {
			//broadcasting renaming map message to every container except the originator
			for each (var container:IContainer in tabContainers) {
				if (m.sender == container)
					continue; //if container sent this message, do not forward it to the container
				container.send(m);
			}
		}

		private function findTabIndexByLabel(label:String):int {
			for (var i:int = 0; i < this.tabContainers.length; i++) {
				var c:IContainer = this.tabContainers[i];
				if (Object(c).hasOwnProperty("label") && (Object(c).label == label))
					return i;
			}
			return -1;
		}


		private function getContainerManager(m:Message):IContainerManager {
			//if (m.body.hasOwnProperty("map") && (m.body.map is MapModel2))
			return new TreeContainerManager(MapModel2(m.body.map), thisView, this.mb, AbstractAction(m.body.rootAction));
		/*else if (m.body is MapModel2)
			return new TreeContainerManager(MapModel2(m.body), thisView, this.mb, AbstractAction(m.body.rootAction));
		else if (m.body.hasOwnProperty("containerType") && (m.body.containerType is Class))
			return new ContainerManager(Class(m.body.containerType), thisView, String(m.body.label), this.mb);
		return null;*/
		}

		private function openInTab(m:Message):void {
			var tabView:Container;
			var container:Container2;
			var element:*; //holds the model, for maps it will be MapModel, for containers - containers themselves
			if (m.body.view != null) {
				tabView = Container(m.body.view);
				container = m.body.container;
				if (this.tabContainers.indexOf(container) == -1) {
					this.tabContainers.push(container);
				}
			} else {
				var containerManager:IContainerManager = getContainerManager(m);
				var label:String = containerManager.getLabel();
				element = containerManager.getObject();
				var tabIndex:int = findTabIndexByLabel(label);

				if (tabIndex >= 0) { //existing container
					container = tabContainers[tabIndex];
					tabView = Object(container).view;
				}

				else { //new container
					container = Container2(containerManager.create());
					this.tabContainers.push(container);
					tabView = Object(container).view;
					container.mb.subscribe(this);
				}
			}
			thisView.selectedChild = tabView;
			this.send(new Message(TreeTabMessages.TAB_CREATED, this, { model: element, container: container }));
		}

		private function tabIndexChangedHandler(event:Event):void {
			if (!(event is IndexChangedEvent))
				return; //can catch other "change" events, eg ListEvent
			//make sure that only IndexChangeEvent are handled here
			var i:int = IndexChangedEvent(event).newIndex;
			onTabIndexChanged(i);
		}

		private function onTabIndexChanged(index:int):void {
			var container:IContainer = IContainer(this.tabContainers[index]);
			//1-tree container has index 1 inside of TreeMenuContainer
			var model:Object = null;
			if (container != null)
				model = (container is TreeMenuContainer) ? TreeMenuContainer(container).getContainerByName("treeContainer").model : Object(container).model;

			//deactivate previous and activate current
			if (previousContainer != null)
				previousContainer.send(new Message(MapMessages.DEACTIVATE, this));

			//container could be null if all tabs are closed
			if (container != null)
				container.send(new Message(MapMessages.ACTIVATE, this));
			this.send(new Message(TreeTabMessages.MAP_TAB_INDEX_CHANGED, this, { model: model, container: container }));
			previousContainer = container;
		}

		private function closeTab(m:Message):void {
			logger.debug("closeTab");
			var mapName:String = m.body.map.name;
			var tabIndex:int = findTabIndexByLabel(mapName);
			if (tabIndex == -1)
				throw new Error("Unable to find tab for " + mapName);
			//don't dispatch SuperTabEvent.TAB_CLOSE, there is a listener already
			//that assumes tab is removed from display list
			//thisView.dispatchEvent(new SuperTabEvent(SuperTabEvent.TAB_CLOSE, tabIndex));
			var container:Container2 = Container2(this.tabContainers[tabIndex]);
			var containerManager:IContainerManager = getContainerManager(m);
			//containerManager maybe null if user clicked on x on the tab
			if (containerManager != null)
				containerManager.destroy(container);
			removeFromTabContainers(tabIndex);

			//force handling of switching a tab
			onTabIndexChanged(tabIndex);
		}

		private function removeFromTabContainers(tabIndex:int):void {
			var container:IContainer = IContainer(this.tabContainers.splice(tabIndex, 1)[0]);
			container.uninitialize();
		}

		private function closeTabHandler(event:SuperTabEvent):void {
			logger.debug("closeTabHandler");

			event.preventDefault();

			//prevent from closing tab if only 1 tab is left
			if (this.tabContainers.length <= 1) {

				return;
			}

			//event.stopImmediatePropagation();//prevent default handler from being executed
			/* var tabIndex:int = event.tabIndex;
			//remove container from the list
			//the container should have uninitialized itself already
			removeFromTabContainers(tabIndex); */

			//assume that container is a map container
			var tabContainer:TreeMenuContainer = TreeMenuContainer(this.tabContainers[event.tabIndex]);
			var map:MapModel2 = MindMapTreeContainer(tabContainer.containers[1]).map;
			var closeAction:AbstractUserAction = tabContainer.getAvailableActionByType(CloseMap);
			if (closeAction == null)
				throw new Error("Unable to close. Close Map action is not found");
			closeAction.input.mapContainer = tabContainer;
			closeAction.input.map = map;
			closeAction.initialize();
			closeAction.userExecute();
			//this.send(new Message(TreeTabMessages.CLOSE_MAP_IN_TAB, this, {name:map.name, map:map}), true);
		}
	}
}
