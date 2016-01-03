package mindmaps2.map.controllers {
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.map.messages.NodeMessages;

	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.map.ui.MindMapTreeEditor;
	import mindmaps2.map.ui.MindMapTreeEditorEvent;

	public class MindMapObserverController extends AbstractController {

		public function MindMapObserverController(editor:MindMapTreeEditor) {
			super();
			this.editor = editor;
		}

		private var editor:MindMapTreeEditor;

		override public function initialize():void {
			super.initialize();

			editor.addEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_END, onElementEditEnd);
		}

		override public function uninitialize():void {
			editor.removeEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_END, onElementEditEnd);

			super.uninitialize();
		}

		override public function receive(m:Message):void {
			switch (m.name) {
				case NodeMessages.ADDED_NODE:
				case NodeMessages.REMOVED_NODE:
				case NodeMessages.CONVERTED_NODE:
					sendChangedMapMessage();
					break;
			}
		}

		private function sendChangedMapMessage():void {
			this.send(new Message(MindMapMessages.CHANGED_MAP, this, {}));
		}

		private function onElementEditEnd(event:MindMapTreeEditorEvent):void {
			sendChangedMapMessage();
		}
	}
}
