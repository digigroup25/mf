package mindmaps2.storage {
	import collections.*;

	import converters.XmlCollectionConverter;

	import mindmaps.map.MapModel2;

	[Bindable]
	[RemoteClass(alias = "org.pyamf.examples.simple.Map")]
	public class PersistentMap {
		public var id:int;

		public var name:String;

		public var mapData:String;

		public var version:int = 0;

		//public var isPublished:Boolean;
		public var isPrivate:Boolean;

		public var lastModified:Date = new Date();

		public var owner:String;

		public function toString():String {
			return /*mapData.toString();*/ id + ", " + name;
		}

		public function toMapModel():MapModel2 {
			var nodes:TreeCollectionEx = new XmlCollectionConverter().fromXml(XML(mapData), new TreeCollectionEx());
			var res:MapModel2 = new MapModel2(nodes, name);
			res.id = id.toString();
			return res;
		}

		public function fromMapModel(map:MapModel2):void {
			this.id = parseInt(map.id);
			this.name = map.name;
			if (map.nodes)
				this.mapData = new XmlCollectionConverter().toXml(map.nodes);
		}
	}

}
