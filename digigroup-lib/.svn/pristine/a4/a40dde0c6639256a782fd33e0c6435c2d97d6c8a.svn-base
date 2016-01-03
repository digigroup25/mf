package mapstorage.ui {
	import actions.AbstractAction;
	import actions.AbstractUserAction;

	import assertions.Require;

	import components.MapNameInput;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import logging.LogUtil;

	import mapstorage.*;

	import mf.framework.*;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.PopUpMessagesFactory;

	import mindmaps2.actions.map.SelectMap2;
	import mindmaps2.storage.*;
	import mindmaps2.storage.services.*;

	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.logging.ILogger;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;

	public class LocalMapStorageWindowController extends AbstractController {

		private static const logger:ILogger = LogUtil.getLogger(LocalMapStorageWindowController);

		public function LocalMapStorageWindowController(localMapRepo:IMapRepository,
			parent:DisplayObjectContainer, rootAction:AbstractAction) {
			this.localMapRepo = localMapRepo;
			this.parent = parent;
			this.rootAction = rootAction;

			this.mapStorageMessages = new MapStorageMessageFactory(this);
			this.popUpMessages = new PopUpMessagesFactory(this);
			this._messageHandler = this.receiveHandler;
		}

		public var localMaps:ArrayCollection = new ArrayCollection();

		private var parent:DisplayObjectContainer;

		private var localMapRepo:IMapRepository;

		private var newMapsCounter:int = 0;

		private var mapToRenameIndex:int = -1; //index of map when renaming and pressing enter, keeps selected

		private var mapStorageMessages:MapStorageMessageFactory;

		private var rootAction:AbstractAction;

		private var popUpMessages:PopUpMessagesFactory;

		private var addMapWindow:MapNameInput;

		private var renameMapWindow:MapNameInput;

		override public function initialize():void {
			logger.debug("initialize");

			super.initialize();
			thisView.label = "Map Directory";
		}

		//temporary method name
		public function initView():void {
			logger.debug("initView");
			thisView.addEventListener(MapStorageEvent.NAME, onEvent);

			thisView.localMaps = this.localMaps;

			var sort:Sort = new Sort();
			sort.fields = [ new SortField("lastModified", true, true, true)];
			thisView.localMaps.sort = sort;

			thisView.webMaps.sort = sort;

			thisView.callLater(getLocalMaps);
		}

		override public function uninitialize():void {
			logger.debug("uninitialize");
			//remove all event listeners
			thisView.removeEventListener(MapStorageEvent.NAME, onEvent);
			if (parent != null && parent.contains(thisView))
				parent.removeChild(thisView);
			parent = null;
			localMapRepo = null;
			super.uninitialize();
		}

		private function get thisView():MapStorage {
			return MapStorage(model);
		}

		private function getLocalMaps():void {
			logger.debug("getLocalMaps");
			var token:AsyncToken = localMapRepo.getMaps();
			token.addResponder(new AsyncResponder(onGetLocalMaps, fault, {}));
		}

		private function onGetLocalMaps(event:ResultEvent, token:Object):void {
			logger.debug("onGetLocalMaps");
			this.localMaps.source = event.result.maps.source;
		}

		private function fault(event:FaultEvent, token:Object):void {
			throw new Error(event.toString());
		}

		private function onMapDoubleClick(e:MouseEvent):void {
			var mapStorageEvent:MapStorageEvent = new MapStorageEvent(MapStorageEvent.OPEN_MAP);
			mapStorageEvent.isWeb = false;
			thisView.dispatchEvent(mapStorageEvent);
		}

		private function onEvent(e:MapStorageEvent):void {
			logger.debug(StringUtil.substitute("onEvent: action={0}, isWeb={1}", e.action, e.isWeb));
			var m:Message;
			var map:MapModel2;

			if (e.isWeb)
				return;
			if ((e.action != MapStorageEvent.DELETE_ALL_MAPS) && (e.action != MapStorageEvent.NEW_MAP))
				map = MapModel2(thisView.localMapsList.selectedItem);


			switch (e.action) {
				case MapStorageEvent.SELECTED_MAP:
					m = mapStorageMessages.SelectedMap(map);
					break;
				case MapStorageEvent.NEW_MAP:
					newMapsCounter++;
					m = mapStorageMessages.NewMap("New Map " + newMapsCounter);
					break;
				case MapStorageEvent.OPEN_MAP:
					m = mapStorageMessages.GetMap(map.name, map.id);
					break;
				case MapStorageEvent.GET_MAPS:
					m = mapStorageMessages.GetMaps();
					break;
				case MapStorageEvent.DELETE_MAP:
					m = mapStorageMessages.DeleteMap(map.name);
					break;
				case MapStorageEvent.RENAME_MAP:
					m = mapStorageMessages.RenameMap(map, null);
					mapToRenameIndex = thisView.localMapsList.selectedIndex;
					break;
				case MapStorageEvent.DELETE_ALL_MAPS:
					m = mapStorageMessages.DeleteAllMaps();
					break;
				default:
					throw new Error("Unknown event type " + e.type);
			}
			if (m != null) {
				//create empty body if null
				if (m.body == null)
					m.body = {};
				mb.send(m, true); //explicitly send to yourself
			}
		}

		private function receiveHandler(m:Message):void {
			switch (m.name) {
				case MapStorageMessages.GET_MAPS:
					onGetMaps(m);
					break;
				case MapStorageMessages.SHOW_WINDOW:
					onShowWindow(m);
					break;
				case MapStorageMessages.DELETED_MAP:
					onMapDeleted(m);
					break;
				case MapStorageMessages.NEW_MAP:
					onNewMap(m);
					break;
				case MapStorageMessages.NEWED_MAP:
					onMapNewed(m);
					break;
				case MapStorageMessages.RENAME_MAP:
					onRenameMap(m);
					break;
				case MapStorageMessages.RENAMED_MAP:
					onRenamedMap(m);
					break;

				case MapStorageMessages.SAVED_MAP:
					onSavedMap(m);
					break;

				case MapStorageMessages.SELECTED_MAP:
					onSelectedMap(m);
					break;
			}
		}

		private function onSavedMap(m:Message):void {
			logger.debug("onSavedMap");
			getLocalMaps();
		}

		private function onShowWindow(m:Message):void {
			logger.debug("onShowWindow");
			getLocalMaps();
		}

		private function onGetMaps(m:Message):void {
			logger.debug("onGetMaps");
			getLocalMaps();
		}

		private function onNewMap(m:Message):void {
			logger.debug("onNewMap");

			m.destroy();

			addMapWindow = new MapNameInput();
			addMapWindow.title = "Add a new map";
			PopUpManager.addPopUp(addMapWindow, DisplayObject(FlexGlobals.topLevelApplication));
			PopUpManager.centerPopUp(addMapWindow);
			addMapWindow.setFocus();

			addMapWindow.addEventListener("close", onAddMapWindowClose);
			addMapWindow.addEventListener("actionClick", onAddMapWindowClick);
		}

		private function onAddMapWindowClose(event:Event):void {
			removeWindow(addMapWindow);
		}

		private function removeWindow(window:IFlexDisplayObject):void {
			try {
				//VR 6/5/11 for some reason this throws NPE exception, but still removes popup ???
				PopUpManager.removePopUp(window);
					//mapNameInputWindow.close();
			} catch (e:Error) {
			}
		}

		private function onAddMapWindowClick(event:Event):void {
			var newMapName:String = addMapWindow.mapName.text;
			var m:Message = mapStorageMessages.NewMap(newMapName);
			this.send(m);
		}

		private function onRenameMap(m:Message):void {
			logger.debug("onRenameMap");
			m.destroy();

			var renamedMap:MapModel2 = MapModel2(thisView.localMapsList.selectedItem);

			renameMapWindow = new MapNameInput();
			renameMapWindow.title = "Rename a map";
			renameMapWindow.action = "Rename";
			PopUpManager.addPopUp(renameMapWindow, DisplayObject(FlexGlobals.topLevelApplication));
			PopUpManager.centerPopUp(renameMapWindow);
			renameMapWindow.setFocus();

			renameMapWindow.addEventListener("close", onRenameMapWindowClose);
			renameMapWindow.addEventListener("actionClick", onRenameMapWindowClick);
		}

		private function onRenameMapWindowClose(event:Event):void {
			removeWindow(renameMapWindow);
		}

		private function onRenameMapWindowClick(event:Event):void {
			var renamedMap:MapModel2 = MapModel2(thisView.localMapsList.selectedItem);
			var newMapName:String = renameMapWindow.mapName.text;
			var m:Message = mapStorageMessages.RenameMap(renamedMap, newMapName);
			this.send(m);
		}

		private function onRenamedMap(m:Message):void {
			logger.debug("onRenamedMap");

			var result:Boolean = m.body.result;
			if (!result) {
				this.renameMapWindow.error = m.body.error;
				return;
			}

			removeWindow(renameMapWindow);

			this.getLocalMaps();
		}

		private function onSelectedMap(m:Message):void {
			logger.debug("onSelectedMap");
			var allSelectActions:Array = rootAction.getAvailableActions(SelectMap2);
			//Require.collectionSize(allSelectActions, "allSelectActions", 1);
			var selectMapAction:AbstractUserAction = AbstractUserAction(allSelectActions[0]);

			Require.notNull(m.body.map, "map");
			var map:MapModel2 = MapModel2(m.body.map);
			selectMapAction.input.map = map;
			selectMapAction.initialize();
			selectMapAction.userExecute();
		}

		private function onMapNewed(m:Message):void {
			logger.debug("onMapNewed");
			var result:Boolean = m.body.result;

			if (!result) {
				this.addMapWindow.error = m.body.error;
				return;
			}

			this.removeWindow(this.addMapWindow);

			this.getLocalMaps();
		}

		private function onMapDeleted(m:Message):void {
			logger.debug("onMapDeleted");
			getLocalMaps();
		}
	}
}
