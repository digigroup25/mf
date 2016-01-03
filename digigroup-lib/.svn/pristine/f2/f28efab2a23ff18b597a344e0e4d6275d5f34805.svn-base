package mindmaps2.storage {
	import collections.TreeCollectionEx;

	import converters.XmlCollectionConverter_1_0;

	import factories.TreeFactory;

	import mx.collections.*;
	import mx.utils.UIDUtil;

	import vos.Item;

	public class PersistentMapFactory {
		private var xcc:XmlCollectionConverter_1_0 = new XmlCollectionConverter_1_0();

		public function createMap(mapName:String = null):PersistentMap {
			var res:PersistentMap = new PersistentMap();
			//res.id = UIDUtil.createUID();
			res.id = 0;
			res.version = 0;
			//res.isPublished = false;
			var item:Item = new Item();
			(mapName == null) ? item.name = "New Item" : item.name = mapName;
			res.mapData = xcc.toXml(new TreeCollectionEx(item, true));
			return res;
		}

		public function createSimpleMap():PersistentMap {
			var res:PersistentMap = new PersistentMap();
			res.name = "SimpleMap";
			res.version = 1;
			res.mapData = xcc.toXml(new TreeFactory().createSimpleCollection());
			return res;
		}

		public function create1Map():ArrayCollection {
			var col:ArrayCollection = new ArrayCollection();
			var map:PersistentMap = createSimpleMap();
			col.addItem(map);
			return col;
		}

		public function create2Maps():ArrayCollection {
			var col:ArrayCollection = create1Map();
			var map:PersistentMap = createSimpleMap();
			map.name = "SimpleMap2";
			map.version = 2;
			col.addItem(map);
			return col;
		}

		public function create3Maps():ArrayCollection {
			var col:ArrayCollection = create2Maps();
			var map:PersistentMap = new PersistentMap();
			map.name = "SimpleMap3";
			map.version = 3;
			map.mapData = xcc.toXml(new TreeFactory().create1NodeCollection_Appointment());
			col.addItem(map);
			return col;
		}
	}
}
