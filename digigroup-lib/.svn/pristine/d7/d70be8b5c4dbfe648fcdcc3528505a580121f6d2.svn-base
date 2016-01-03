package mindmaps.map.ui.tree.messages {
	import actions.AbstractAction;

	import mf.framework.Container2;
	import mf.framework.ISender;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;

	public class TreeTabMessageFactory {

		public function TreeTabMessageFactory(sender:ISender) {
			this.sender = sender;
		}

		private var sender:ISender;

		public function createOpenMap(map:MapModel2, rootAction:AbstractAction):Message {
			return new Message(TreeTabMessages.OPEN_MAP_IN_TAB, sender,
				{ map: map, rootAction: rootAction });
		}

		public function createRenameMap(map:MapModel2, oldMapName:String):Message {
			return new Message(TreeTabMessages.RENAME_MAP_IN_TAB, sender,
				{ map: map, oldMapName: oldMapName });
		}
	}
}
