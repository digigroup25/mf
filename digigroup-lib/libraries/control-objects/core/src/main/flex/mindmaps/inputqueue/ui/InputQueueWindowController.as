package mindmaps.inputqueue.ui {
	import components.*;

	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.inputqueue.InputQueueMessages;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.PopUpMessagesFactory;

	public class InputQueueWindowController extends AbstractController {
		public function InputQueueWindowController(model:IModelProvider = null, mb:IMessageBroker = null, messageHandler:Function = null) {
			super(model, mb, messageHandler);
			if (model != null)
				window = InputTextLineWindow(model);

			popupMessages = new PopUpMessagesFactory(this);
			nodeMessages = new NodeMessageFactory(this);
		}

		private var window:InputTextLineWindow;

		private var popupMessages:PopUpMessagesFactory;

		private var firstTime:Boolean = true;

		private var nodeMessages:NodeMessageFactory;

		override public function receive(m:Message):void {
			switch (m.name) {
				case InputQueueMessages.SHOW_INPUT_QUEUE:
					onShowInputQueue(m);
					break;
			}
		}

		private function onShowInputQueue(m:Message):void {
			if (window == null) {
				window = new InputTextLineWindow();
				window.addEventListener(InputTextLineWindowEvent.TEXT_ADDED, onAddToQueue);
			}
			this.send(popupMessages.addPopUp(window, "Add task to Inbox", null, null,
				{ horizontal: "right", vertical: "bottom" }));

			setWindowFocus();

		}

		private function setWindowFocus():void {
			window.callLater(function():void {window.setFocus()});
		}

		private function onAddToQueue(event:InputTextLineWindowEvent):void {
			var input:String = event.text;
			if (input == "")
				return; //ignore if a user did not input anything
			this.send(new Message(InputQueueMessages.ADD_TO_INPUT_QUEUE, this, { name: input, token: { selectNode: false }}));
			window.input = ""; //reset input to empty

			setWindowFocus();
		}
	}
}
