package mindmaps2.storage {
	import flash.display.DisplayObjectContainer;

	import mf.framework.Container2;
	import mf.framework.IMessageBroker;

	import mindmaps2.storage.services.*;

	public class MapStorageContainer2 extends Container2 {
		//private var windowController:MapStorageWindowController;

		public function MapStorageContainer2(parent:DisplayObjectContainer, mb:IMessageBroker, label:String,
			localMapRepo:IMapRepository = null, webMapRepo:IMapRepository = null) {
			super(mb);

			if (localMapRepo == null)
				localMapRepo = MapRepositoryFactory.localRepo();
			if (webMapRepo == null)
				webMapRepo = MapRepositoryFactory.webRepo();

			//windowController = new MapStorageWindowController(parent, label);
			var mapController:MapStorageController = new MapStorageController(null);
			this.controllers = [ /*windowController,*/ mapController ];
			ServiceLocator.getInstance().register(MapRepositories.WEB, webMapRepo);
			ServiceLocator.getInstance().register(MapRepositories.LOCAL, localMapRepo);
			ServiceLocator.getInstance().register(MapRepositories.NULL, new NullMapRepository());
		}
	}
}
