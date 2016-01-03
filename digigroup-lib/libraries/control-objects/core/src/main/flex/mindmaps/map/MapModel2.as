package mindmaps.map {
	import collections.TreeCollectionEx;

	import commonutils.*;

	public class MapModel2 implements ICloneable {

		public function MapModel2(nodes:TreeCollectionEx = null, name:String = null, lastModified:Date = null) {
			this.nodes = nodes;
			this.name = name;
			this._lastModified = lastModified;
		}

		public var id:String;

		public var nodes:TreeCollectionEx;

		[Bindable]
		public var name:String;

		private var _lastModified:Date;

		public function get lastModified():Date {
			return _lastModified;
		}

		public function clone():Object {
			var clone:MapModel2 = MapModel2(DeepCopy.clone(this, true));
			return clone;
		}
	}
}
