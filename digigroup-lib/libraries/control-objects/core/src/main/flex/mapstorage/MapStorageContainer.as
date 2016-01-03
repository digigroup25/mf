package mapstorage {

	import actions.AbstractAction;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import logging.LogUtil;

	import mapstorage.ui.LocalMapStorageWindowController;
	import mapstorage.ui.MapStorage;
	import mapstorage.ui.WebMapStorageWindowController;

	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.Message;
	import mf.framework.MessageBroker;
	import mf.framework.ViewContainerDecorator;
	import mf.framework.messaging.Connector;
	import mf.framework.messaging.MessageFilterFactory;

	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;

	import mindmaps2.storage.MapStorageController;
	import mindmaps2.storage.MapStorageMessages;
	import mindmaps2.storage.services.*;

	import mx.containers.TabNavigator;
	import mx.logging.ILogger;

	public class MapStorageContainer extends ViewContainerDecorator {

		private static const logger:ILogger = LogUtil.getLogger(MapStorageContainer);

		public function MapStorageContainer(parent:DisplayObjectContainer, mb:IMessageBroker, lbl:String, view:MapStorage,
			localMapRepo:IMapRepository, webMapRepo:IMapRepository, elementTypes:Array,
			rootAction:AbstractAction) {
			if (view == null)
				view = new MapStorage();
			var c:Container2 = new Container2(mb, null, null, handleMessage);
			super(c, view);

			//b/c there is no container wrapper
			//this.parent =  view;
			setLabel(lbl);
			this.rootAction = rootAction;

			if (localMapRepo == null)
				localMapRepo = new MapRepositoryFactory.localRepoClass(elementTypes);
			if (webMapRepo == null)
				webMapRepo = new WebMapRepository();

			var viewContainer:Container2 = new Container2(mb, view);
			viewContainer.name = "view";

			var localMapStorageMb:MessageBroker = new MessageBroker();
			localMapStorageConnector = new Connector(mb, localMapStorageMb, MessageFilterFactory.excludeAll(),
				MessageFilterFactory.includeOnly(MapStorageMessages.GOT_MAP, MapStorageMessages.SAVED_MAP));


			localMapStorageContainer = new Container2(localMapStorageMb, view, [
				new LocalMapStorageWindowController(localMapRepo, parent, rootAction),
				new MapStorageController(localMapRepo)
				]);

			var webMapStorageMb:MessageBroker = new MessageBroker();
			webMapStorageConnector = new Connector(mb, webMapStorageMb, MessageFilterFactory.excludeAll(),
				MessageFilterFactory.includeOnly(MapStorageMessages.GOT_MAP, MapStorageMessages.SAVED_MAP));

			webMapStorageContainer = new Container2(webMapStorageMb, view, [
				new WebMapStorageWindowController(webMapRepo, parent, rootAction),
				new MapStorageController(webMapRepo)
				]);

			viewContainer.containers = [ localMapStorageContainer, webMapStorageContainer ]

			this.containers = [ viewContainer ];

			ServiceLocator.getInstance().register(MapRepositories.WEB, webMapRepo);
			ServiceLocator.getInstance().register(MapRepositories.LOCAL, localMapRepo);
			ServiceLocator.getInstance().register(MapRepositories.NULL, new NullMapRepository());

		}

		private var _label:String;

		private var _view:Object;

		private var localMapStorageContainer:Container2;

		private var localMapStorageConnector:Connector;


		private var webMapStorageContainer:Container2;

		private var webMapStorageConnector:Connector;

		private var rootAction:AbstractAction;

		public function get label():String {
			return _label;
		}

		protected function setLabel(value:String):void {
			_label = value;
			if ((_view != null) && (_view.hasOwnProperty("label"))) {
				Object(_view)["label"] = value;
			}
		}

		protected function get viewContainer():Container2 {
			return this.getContainerByName("view");
		}

		override protected function doInitialize():void {
			logger.debug("doInitialize");
			super.doInitialize();
			ServiceLocator.getInstance().initialize();

			localMapStorageConnector.initialize();
			webMapStorageConnector.initialize();
		}

		override protected function doUninitialize():void {
			logger.debug("doUninitialize");
			ServiceLocator.getInstance().uninitialize();

			localMapStorageConnector.uninitialize();
			webMapStorageConnector.uninitialize();

			super.doUninitialize();
		}

		private function handleMessage(m:Message):void {
			switch (m.name) {
				case MapMessages.OPEN_MAP_DIRECTORY_IN_TAB:
					onOpenMapDirectoryInTab(m);
					break;
				case MapStorageMessages.GOT_MAP:
					logger.debug("handleMessage GOT_MAP");
					break;
			}

		}

		private function onOpenMapDirectoryInTab(m:Message):void {
			var tabNavigator:TabNavigator = TabNavigator(m.body.parent);
			//activate view controllers - local and web
			var localController:LocalMapStorageWindowController = localMapStorageContainer.controllers[0];
			var webController:WebMapStorageWindowController = webMapStorageContainer.controllers[0];

			if (!tabNavigator.contains(DisplayObject(viewContainer.model))) {
				tabNavigator.addChild(DisplayObject(viewContainer.model));
				localController.initView();
				webController.initView();
			}


			this.send(new Message(TreeTabMessages.OPEN_MAP_IN_TAB, this, { view: localController.model,
					container: this }));

		}
	}
}
