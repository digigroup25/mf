package mindmaps2.storage {
	import mf.framework.Message;

	import mindmaps.map.MapModel2;

	import mx.collections.ArrayCollection;

	public class MapStorageMessageFactory {

		public function MapStorageMessageFactory(sender:Object) {
			this.sender = sender;
		}

		protected var sender:Object;

		public function SelectedMap(map:MapModel2):Message {
			return new Message(MapStorageMessages.SELECTED_MAP, sender, { map: map });
		}

		public function NewMap(mapName:String):Message {
			return new Message(MapStorageMessages.NEW_MAP, sender, { mapName: mapName });
		}

		public function GetMap(mapName:String, mapId:String):Message {
			return new Message(MapStorageMessages.GET_MAP, sender, { mapName: mapName, mapId: mapId });
		}

		public function GotMap(map:MapModel2):Message {
			return new Message(MapStorageMessages.GOT_MAP, sender, { map: map });
		}

		public function GetMaps():Message {
			return new Message(MapStorageMessages.GET_MAPS, sender);
		}

		public function GotMaps(maps:ArrayCollection):Message {
			return new Message(MapStorageMessages.GOT_MAPS, sender, { maps: maps });
		}

		public function RenameMap(map:MapModel2, newMapName:String):Message {
			return new Message(MapStorageMessages.RENAME_MAP, sender,
				{ map: map, newMapName: newMapName });
		}

		public function RenamedMap(result:Boolean, error:String, map:MapModel2, oldMapName:String):Message {
			return new Message(MapStorageMessages.RENAMED_MAP, sender,
				{ result: result, error: error, map: map, oldMapName: oldMapName });
		}

		public function DeleteMap(mapName:String):Message {
			return new Message(MapStorageMessages.DELETE_MAP, sender, { mapName: mapName });
		}

		public function DeleteAllMaps():Message {
			return new Message(MapStorageMessages.DELETE_ALL_MAPS, sender, {});
		}

		public function SaveMap(map:MapModel2):Message {
			return new Message(MapStorageMessages.SAVE_MAP, sender, { map: map });
		}

		public function SavedMap(map:MapModel2):Message {
			return new Message(MapStorageMessages.SAVED_MAP, sender, { map: map });
		}

		public function ShowWindow():Message {
			return new Message(MapStorageMessages.SHOW_WINDOW, sender);
		}

		public function HideWindow():Message {
			return new Message(MapStorageMessages.HIDE_WINDOW, sender);
		}

		public function Login(userName:String, password:String):Message {
			return new Message(MapStorageMessages.LOGIN, sender, { userName: userName, password: password });
		}

		public function LoggedIn():Message {
			return new Message(MapStorageMessages.LOGGED_IN, sender);
		}

		public function Logout(userName:String, password:String):Message {
			return new Message(MapStorageMessages.LOGOUT, sender, { userName: userName, password: password });
		}

		public function LoggedOut():Message {
			return new Message(MapStorageMessages.LOGGED_OUT, sender);
		}
	}
}
