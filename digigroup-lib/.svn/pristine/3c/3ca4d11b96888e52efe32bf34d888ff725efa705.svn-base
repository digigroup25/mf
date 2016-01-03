package mindmaps2.storage {

	import logging.LogUtil;

	import mapstorage.*;

	import mf.framework.AbstractController;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;

	import mindmaps2.storage.services.*;

	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class MapStorageController extends AbstractController {

		private static const logger:ILogger = LogUtil.getLogger(MapStorageController);

		public function MapStorageController(repo:IMapRepository) {
			mapStorageMessages = new MapStorageMessageFactory(this);
			this.repo = repo;
		}

		private var repo:IMapRepository;

		private var mapStorageMessages:MapStorageMessageFactory;

		override public function receive(m:Message):void {
			switch (m.name) {

				case MapStorageMessages.GET_MAPS:
					onGetMaps(m);
					break;
				case MapStorageMessages.GET_MAP:
					onGetMap(m);
					break;
				case MapStorageMessages.NEW_MAP:
					onNewMap(m);
					break;
				case MapStorageMessages.DELETE_MAP:
					onDeleteMap(m);
					break;
				case MapStorageMessages.DELETE_ALL_MAPS:
					onDeleteAllMaps(m);
					break;
				case MapStorageMessages.RENAME_MAP:
					onRenameMap(m);
					break;
				case MapStorageMessages.SAVE_MAP:
					onSaveMap(m);
					break;
				case MapStorageMessages.UPLOAD_MAP:
					/*onPublishMap(m);*/
					break;

				case MapStorageMessages.LOGIN:
					onLogin(m);
					break;

				case MapStorageMessages.LOGOUT:
					onLogout(m);
					break;
			}
		}

		private function onLogin(m:Message):void {
			WebMapRepository(repo).login(m.body.userName, m.body.password);
			this.send(mapStorageMessages.LoggedIn());
		}

		private function onLogout(m:Message):void {
			WebMapRepository(repo).logout();
			this.send(mapStorageMessages.LoggedOut());
		}

		private function onGetMaps(m:Message):void {
			var token:AsyncToken = repo.getMaps();
			token.addResponder(new AsyncResponder(onGetMapsResult, onFault, token));
		}

		private function onGetMapsResult(event:ResultEvent, token:Object):void {
			var m:Message = mapStorageMessages.GotMaps(event.result.maps);
			this.send(m);
		}

		private function onNewMap(m:Message):void {
			var mapName:String  = m.body.mapName;
			var map:MapModel2 = new MapModel2Factory().createEmptyMap(mapName);
			var token:AsyncToken = repo.addMap(map, {});
			token.addResponder(new AsyncResponder(onNewMapResult, onFault, token));
		}

		private function onNewMapResult(event:ResultEvent, token:Object):void {
			var map:MapModel2 = MapModel2(event.result.mapModel);
			var m:Message = new Message(MapStorageMessages.NEWED_MAP, this,
				{
					result: event.result.result,
					error: event.result.error,
					map: map
				});
			this.send(m);
		}

		private function onFault(event:FaultEvent, token:Object):void {
			throw new Error("Error, should not be here");
		}

		private function onGetMap(m:Message):void {
			logger.debug("onGetMap");
			var mapName:String  = m.body.mapName;
			var mapId:String = m.body.mapId;
			var asyncToken:AsyncToken = repo.getMap(mapName, mapId);
			asyncToken.addResponder(new AsyncResponder(onGotMapResult, onFault, {}));
		}

		private function onGotMapResult(result:ResultEvent, token:Object):void {
			logger.debug("onGotMapResult");
			var map:MapModel2 = MapModel2(result.result);
			var m:Message = new Message(MapStorageMessages.GOT_MAP, this, { map: map, mapStorageContainer: this.container });
			this.send(m);
		}

		private function onDeleteMap(m:Message):void {
			var mapName:String  = m.body.mapName;
			repo.deleteMap(mapName, onDeleteMapResult);

		}

		private function onDeleteMapResult():void {
			this.send(new Message(MapStorageMessages.DELETED_MAP, this));
		}

		private function onDeleteAllMaps(m:Message):void {
			var mapName:String  = m.body.mapName;
			repo.deleteAllMaps(onDeleteAllMapsResult);

		}

		private function onDeleteAllMapsResult():void {
			this.send(new Message(MapStorageMessages.DELETED_MAP, this));
		}

		private function onRenameMap(m:Message):void {
			var map:MapModel2  = MapModel2(m.body.map);
			var newMapName:String = String(m.body.newMapName);
			var token:Object = { oldMapName: map.name };
			var asyncToken:AsyncToken = repo.renameMap(map, newMapName, token);
			asyncToken.addResponder(new AsyncResponder(onRenameMapResult, onFault, token));
		}

		private function onRenameMapResult(event:ResultEvent, token:Object):void {
			var result:Object = event.result;
			var map:MapModel2 = MapModel2(result.mapModel);
			var m:Message = mapStorageMessages.RenamedMap(result.result as Boolean, result.error, map, result.oldMapName);
			send(m);
		}

		private function onSaveMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			var token:AsyncToken = repo.saveMap(map, null);
			token.addResponder(new AsyncResponder(onSaveMapResult, onFault, token));

		}

		private function onSaveMapResult(event:ResultEvent, token:AsyncToken):void {
			//trace ("map saved", "refresh map catalog");
			var map:MapModel2 = MapModel2(event.result.mapModel);
			send(mapStorageMessages.SavedMap(map));
		}
	}
}
