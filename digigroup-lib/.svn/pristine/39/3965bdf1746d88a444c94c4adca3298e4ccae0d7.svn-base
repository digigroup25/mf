package mindmaps.map.ui.actions.messages {
	import collections.TreeCollectionEx;

	import mf.framework.Message;

	import mindmaps.map.MapFormat;
	import mindmaps.map.MapModel2;

	import mindmaps2.map.ui.MindMapMessages;

	public class MapMessageFactory {

		public function MapMessageFactory(sender:Object) {
			this.sender = sender;
		}

		private var sender:Object;

		public function DisplayData(data:*, refreshMessage:Message):Message {
			return new Message(MapMessages.DISPLAY_RESULTS, sender, { data: data,
					refreshMessage: refreshMessage });
		}

		public function Prioritized(data:*, node:TreeCollectionEx, token:Object):Message {
			return new Message(MapMessages.PRIORITIZED, sender, { data: data, node: node, token: token });
		}

		public function RefreshMap():Message {
			return new Message(MapMessages.REFRESH_MAP, sender);
		}



		public function Statistics(map:MapModel2):Message {
			return new Message(MapMessages.STATISTICS, sender, { map: map });
		}
	}
}
