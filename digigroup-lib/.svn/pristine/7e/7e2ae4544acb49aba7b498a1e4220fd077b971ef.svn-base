package services
{
	import collections.TreeCollectionEx;
	
	import converters.XmlCollectionConverter;
	
	import factories.TreeFactory;
	
	import mindmaps2.storage.PersistentMap;
	import mindmaps2.storage.services.MapPersistor;
	
	import mx.collections.ArrayCollection;

	public class MapPersistorMock extends MapPersistor
	{
		public var maps:ArrayCollection;
		public function MapPersistorMock(catalogName:String=null, voTypes:Array=null)
		{
			super(catalogName, voTypes);
			var map1:PersistentMap = new PersistentMap(); map1.name = "a";
			var map2:PersistentMap = new PersistentMap(); map2.name = "b";
			maps = new ArrayCollection([map1, map2]);
		}
		
		override public function loadMaps():ArrayCollection {
			return maps;
		}
		
		override public function load(name:String):PersistentMap {
			var map:PersistentMap = new PersistentMap();
			map.name = name;
			var nodes:TreeCollectionEx = new TreeFactory().createTaskAppointment();
			map.mapData = new XmlCollectionConverter().toXml(nodes);
			return map;
		}
		
		override public function remove(name:String):void {
			var mapIndex:int = indexOf(name);
			if (mapIndex>=0)
				maps.removeItemAt(mapIndex);
		}
		
		private function indexOf(mapName:String):int {
			for (var i:int=0; i<maps.length; i++) {
				var curMap:PersistentMap = maps[i];
				if (mapName==curMap.name) {
					return i;
				}
			}
			return -1;
		}
		
		override public function contains(mapName:String):Boolean {
			return indexOf(mapName)>=0;
		}
		
		override public function save(map:PersistentMap):void {
			maps.addItem(map);
		}
	}
}