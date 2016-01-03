package mindmaps2.storage.services {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;

	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;

	public class TestMapRepository implements IMapRepository {
		public function TestMapRepository(elementTypes:Array) {
			//maps = new ArrayCollection(mapFactory.createRandomMaps(10, 10));
			maps = new ArrayCollection([ mapFactory.createPriorityMap(), mapFactory.createAllElementsMap()]);
			timer = new Timer(1000);
		}

		public var maps:ArrayCollection;

		private var timer:Timer;

		private var callback:Function;

		private var map:MapModel2;

		private var mapName:String;

		private var token:Object;

		private const mapFactory:MapModel2Factory = new MapModel2Factory();

		public function initialize():void {
		}

		public function uninitialize():void {
		}

		public function getMaps():AsyncToken {
			return null;
		}

		public function getMap(name:String, mapId:String):AsyncToken {
			mapName = name;
			timer.addEventListener(TimerEvent.TIMER, onGetMap);
			timer.start();
			return null;
		}

		public function addMap(map:MapModel2, token:Object):AsyncToken {
			this.map = map;
			this.token = token;

			timer.addEventListener(TimerEvent.TIMER, onAddMap);
			timer.start();
			return null;
		}

		public function saveMap(mapModel:MapModel2, token:Object):AsyncToken {
			return null;
		}

		public function deleteMap(name:String, callback:Function):void {
			callback();
		}

		public function renameMap(map:MapModel2, newName:String, token:Object):AsyncToken {
			//callback(map, token);
			return null;
		}

		public function deleteAllMaps(callback:Function):void {
			callback();
		}

		private function throwMapDoesNotExist(name:String):void {
			throw new Error("Map with the name " + name + " does not exist");
		}

		private function findMap(name:String):MapModel2 {
			for each (var map:MapModel2 in maps) {
				if (map.name == name)
					return map;
			}
			return null;
		}

		private function replaceMap(map:MapModel2):void {
			var oldMap:MapModel2 = findMap(map.name);
			if (oldMap == null)
				throwMapDoesNotExist(map.name);
			var oldMapIndex:int = maps.getItemIndex(oldMap);
			maps.setItemAt(map, oldMapIndex);
		}

		private function onAddMap(event:TimerEvent):void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onAddMap);
			replaceMap(map);
			callback(map, token);
		}

		private function onGetMap(event:TimerEvent):void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onGetMap);

			var map:MapModel2 = findMap(mapName);
			if (map == null)
				throwMapDoesNotExist(mapName);
			var cloneMap:MapModel2 = MapModel2(map.clone());
			callback(cloneMap);
		}
	}
}
