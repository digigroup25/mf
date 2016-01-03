package mindmaps.search.ui {
	import collections.TreeCollectionEx;

	import flash.events.Event;

	public class SearchResultEvent extends Event {
		public static const SELECT:String = "select";

		public function SearchResultEvent(type:String, node:TreeCollectionEx) {
			super(type, false, false);
			this.node = node;
		}

		public var node:TreeCollectionEx;

		override public function clone():Event {
			return new SearchResultEvent(type, node);
		}
	}
}
