package mindmaps.brainstorming
{
	import collections.TreeCollectionEx;
	
	import components.InputTextLineWindow;
	import components.InputTextLineWindowEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.ui.PopUpMessagesFactory;
	
	import mindmaps2.elements.ElementFactory;

	public class BrainstormingWindowController extends AbstractController
	{
		private var openWindows:Dictionary;
		private var popupMessages:PopUpMessagesFactory;
		private var nodeMessages:NodeMessageFactory;
		
		private function get parentWindow():DisplayObjectContainer {
			return DisplayObjectContainer(this.model);
		}
		public function BrainstormingWindowController(model:IModelProvider=null, mb:IMessageBroker=null, messageHandler:Function=null)
		{
			super(model, mb, messageHandler);
			this.popupMessages = new PopUpMessagesFactory(this);
			this.nodeMessages = new NodeMessageFactory(this);
		}
		
		override public function initialize():void {
			super.initialize();
			
			openWindows = new Dictionary();
			
		}
		
		override public function uninitialize():void {
			openWindows = null; 
			
			super.uninitialize();
			
		}
		
		override public function receive(m:Message):void {
			switch (m.name) {
				case BrainstormingMessages.BRAINSTORM: onBrainstorm(m); break;
			}
		}
		
		private function onBrainstorm(m:Message):void {
			//Alert.show("Show brainstorm popup for node "+ m.body);
			var node:TreeCollectionEx = TreeCollectionEx(m.body);
			var window:InputTextLineWindow = this.openWindows[node];
			if (window==null) {
				window = new InputTextLineWindow();
				
				this.send(popupMessages.addPopUp(window, "Brainstorming \"{0}\"", node.vo, "name"));
				
				openWindows[node] = window;
				
				window.addEventListener(Event.CLOSE, onCloseWindow, false, 0, true);
				window.addEventListener(InputTextLineWindowEvent.TEXT_ADDED, onTextAdded, false, 0, true);
			}
			
			//window.inputText.setFocus();
		}
		
		private function onCloseWindow(event:Event):void {
			var window:InputTextLineWindow = InputTextLineWindow(event.target);
			var node:TreeCollectionEx = getNodeByWindow(window);
			if (node!=null) {
				delete openWindows[node];
			}
		}
		
		private function getNodeByWindow(window:InputTextLineWindow):TreeCollectionEx {
			for (var node:Object in openWindows) {
				if (openWindows[node] == window) {
					return TreeCollectionEx(node);
				}
			}
			return null;
		}
		
		private function onTextAdded(event:InputTextLineWindowEvent):void {
			var window:InputTextLineWindow = InputTextLineWindow(event.target);
			var node:TreeCollectionEx = getNodeByWindow(window);
			var newNode:TreeCollectionEx = new ElementFactory().createFromPrototype(node, event.text);
			this.send(nodeMessages.AddChildNode(newNode, node));
			
			//clear window
			window.input = "";
		}
	}
}