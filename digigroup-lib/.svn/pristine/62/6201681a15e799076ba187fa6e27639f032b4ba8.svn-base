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

	public class WebMapStorageWindowController extends AbstractController {

		private static const logger:ILogger = LogUtil.getLogger(WebMapStorageWindowController);

		public function WebMapStorageWindowController(
			webMapRepo:IMapRepository, parent:DisplayObjectContainer, rootAction:AbstractAction) {
			this.webMapRepo = webMapRepo;
			this.parent = parent;
			this.rootAction = rootAction;

			this.mapStorageMessages = new MapStorageMessageFactory(this);
			this.popUpMessages = new PopUpMessagesFactory(this);
			this._messageHandler = this.receiveHandler;

		}

		public var webMaps:ArrayCollection = new ArrayCollection();

		private var parent:DisplayObjectContainer;

		private var webMapRepo:IMapRepository;

		private var newMapsCounter:int = 0;

		private var mapToRenameIndex:int = -1; //index of map when renaming and pressing enter, keeps selected

		private var _webAvailable:Boolean = true;

		private var mapStorageMessages:MapStorageMessageFactory;

		private var rootAction:AbstractAction;

		private var popUpMessages:PopUpMessagesFactory;

		private var addMapWindow:MapNameInput;

		private var renameMapWindow:MapNameInput;

		override public function initialize():void {
			logger.debug("initialize");

			super.initialize();
			WebMapRepository(webMapRepo).messageListener = this;


		}

		//temporary method name
		public function initView():void {
			logger.debug("initView");
			thisView.addEventListener(MapStorageEvent.NAME, onEvent);

			thisView.webMaps = this.webMaps;

			var sort:Sort = new Sort();
			sort.fields = [ new SortField("lastModified", true, true, true)];
			thisView.webMaps.sort = sort;
		}

		override public function uninitialize():void {
			logger.debug("uninitialize");

			//remove all event listeners
			thisView.removeEventListener(MapStorageEvent.NAME, onEvent);
			if (parent != null && parent.contains(thisView))
				parent.removeChild(thisView);
			parent = null;
			webMapRepo = null;
			super.uninitialize();
		}

		private function get thisView():MapStorage {
			return MapStorage(model);
		}

		private function get webAvailable():Boolean {
			return _webAvailable;
		}

		private function set webAvailable(val:Boolean):void {
			if (_webAvailable == val)
				return;
			_webAvailable = val;

			//thisView.webRefresh.label = (val) ? "Refresh" : "Connect";
			showHideComponent(thisView.login, val);
			showHideComponent(thisView.webMapsPanel, val);
		}

		private function showHideComponent(c:UIComponent, show:Boolean):void {
			c.includeInLayout = c.visible = show;
		}

		private function getWebMaps(e:Event = null):void {
			logger.debug("getWebMaps");
			var token:AsyncToken = webMapRepo.getMaps();
			token.addResponder(new AsyncResponder(onGetWebMaps, fault, {}));
		}

		private function onGetWebMaps(event:ResultEvent, token:Object):void {
			logger.debug("onGetWebMaps");
			this.webMaps.source = event.result.maps.source;
		}

		private function fault(event:FaultEvent, token:Object):void {
			throw new Error(event.toString());
		}

		private function onMapDoubleClick(e:MouseEvent):void {
			var mapStorageEvent:MapStorageEvent = new MapStorageEvent(MapStorageEvent.OPEN_MAP);
			mapStorageEvent.isWeb = true;
			thisView.dispatchEvent(mapStorageEvent);
		}

		private function onEvent(e:MapStorageEvent):void {
			logger.debug(StringUtil.substitute("onEvent: action={0}, isWeb={1}", e.action, e.isWeb));

			var m:Message;
			var map:MapModel2;

			if (!e.isWeb)
				return;

			if ((e.action != MapStorageEvent.DELETE_ALL_MAPS) && (e.action != MapStorageEvent.NEW_MAP))
				map = MapModel2(thisView.webMapsList.selectedItem);

			switch (e.action) {
				case MapStorageEvent.SELECTED_MAP:
					m = mapStorageMessages.SelectedMap(map);
					break;
				case MapStorageEvent.OPEN_MAP:
					m = mapStorageMessages.GetMap(map.name, map.id);
					break;
				case MapStorageEvent.GET_MAPS:
					m = mapStorageMessages.GetMaps();
					break;
				case MapStorageEvent.LOGIN:
					m = mapStorageMessages.Login(e.userName, e.password);
					break;
				case MapStorageEvent.LOGOUT:
					m = mapStorageMessages.Logout(e.userName, e.password);
					break;
				case MapStorageEvent.SAVE_MAP:
					m = mapStorageMessages.SaveMap(map);
					break;
				case MapStorageEvent.DELETE_MAP:
					m = mapStorageMessages.DeleteMap(map.id);
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
				case MapStorageMessages.GOT_MAPS:
					onGotMaps(m);
					break;
				case MapStorageMessages.WEB_UNAVAILABLE:
					onWebUnavailable(m);
					break;
				case MapStorageMessages.WEB_AVAILABLE:
					onWebAvailable(m);
					break;
				case MapStorageMessages.DELETED_MAP:
					onMapDeleted(m);
					break;
				case MapStorageMessages.SAVED_MAP:
					getWebMaps();
					break;
				case MapStorageMessages.SELECTED_MAP:
					onSelectedMap(m);
					break;
				case MapStorageMessages.LOGGED_IN:
					onLoggedIn(m);
					break;

				case MapStorageMessages.LOGGED_OUT:
					onLoggedOut(m);
					break;
			}
		}

		private function onGetMaps(m:Message):void {
			logger.debug("onGetMaps");
			getWebMaps();
		}

		private function onGotMaps(m:Message):void {
			logger.debug("onGotMaps");
			var maps:ArrayCollection = ArrayCollection(m.body.maps);
			thisView.webMaps.source = maps.source;
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

		private function onWebAvailable(m:Message):void {
			webAvailable = true;
			thisView.status.text = "";
		}

		private function onWebUnavailable(m:Message):void {
			//Alert.show(m.body.message);
			webAvailable = false;
			thisView.status.text = m.body.message;
		}

		private function onMapDeleted(m:Message):void {
			logger.debug("onMapDeleted");
			getWebMaps();
		}

		private function onLoggedIn(m:Message):void {
			thisView.loggedIn = true;
		}

		private function onLoggedOut(m:Message):void {
			thisView.loggedIn = false;
		}
	}
}
