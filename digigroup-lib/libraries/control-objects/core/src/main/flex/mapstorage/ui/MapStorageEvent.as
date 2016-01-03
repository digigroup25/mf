package mapstorage.ui {
	import flash.events.Event;

	public class MapStorageEvent extends Event {
		public static const SELECTED_MAP:String = "selectedMap";

		public static const GET_MAPS:String = "getMaps";

		public static const NEW_MAP:String = "newMap";

		public static const OPEN_MAP:String = "openMap";

		public static const SAVE_MAP:String = "saveMap";

		public static const DELETE_MAP:String = "deleteMap";

		public static const DELETE_ALL_MAPS:String = "deleteAllMaps";

		public static const RENAME_MAP:String = "renameMap";

		public static const PUBLISH_MAP:String = "publishMap";

		public static const LOGIN:String = "login";

		public static const LOGOUT:String = "logout";

		public static const NAME:String = "mapStorageEvent";

		public function MapStorageEvent(action:String) {
			super(NAME, false, true);
			this.action = action;
		}

		public var isWeb:Boolean;

		public var action:String;

		public var userName:String;

		public var password:String;

		override public function clone():Event {
			var res:MapStorageEvent = new MapStorageEvent(this.action);
			res.isWeb = this.isWeb;
			res.userName = userName;
			res.password = password;
			return res;
		}
	}
}
