package mapstorage.ui {

	public class MapStorageEventFactory {

		public static function createOpenMap(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.OPEN_MAP);
			e.isWeb = isWeb;
			return e;
		}

		public static function createSaveMap(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.SAVE_MAP);
			e.isWeb = isWeb;
			return e;
		}

		public static function createDeleteMap(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.DELETE_MAP);
			e.isWeb = isWeb;
			return e;
		}

		public static function createDeleteAllMaps(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.DELETE_ALL_MAPS);
			e.isWeb = isWeb;
			return e;
		}

		public static function createRenameMap(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.RENAME_MAP);
			e.isWeb = isWeb;
			return e;
		}

		public static function createGetMaps(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.GET_MAPS);
			e.isWeb = isWeb;
			return e;
		}

		public static function createPublishMap():MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.PUBLISH_MAP);
			e.isWeb = false;
			return e;
		}

		public static function createNewMap():MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.NEW_MAP);
			e.isWeb = false;
			return e;
		}

		public static function createRefreshMaps(isWeb:Boolean):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.GET_MAPS);
			e.isWeb = isWeb;
			return e;
		}

		public static function createLogin(userName:String, password:String):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.LOGIN);
			e.isWeb = true;
			e.userName = userName;
			e.password = password;
			return e;
		}

		public static function createLogout(userName:String, password:String):MapStorageEvent {
			var e:MapStorageEvent = new MapStorageEvent(MapStorageEvent.LOGOUT);
			e.isWeb = true;
			e.userName = userName;
			e.password = password;
			return e;
		}
	}
}
