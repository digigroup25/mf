package mindmaps2.central.ui
{
	import flash.events.MouseEvent;
	
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;
	import mf.framework.ViewContainer;
	
	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.ui.ApplicationMessages;

	public class CentralViewController extends AbstractController
	{
		private function get centralView():CentralArea {
			return CentralArea(model);
		}
		
		private var mapContainers:Object = {};
		
		public function CentralViewController(modelProvider:IModelProvider, mb:IMessageBroker=null)
		{
			super(modelProvider, mb);
		}
		
		override public function initialize():void {
			super.initialize();
			
			centralView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override public function receive(m:Message):void {
			switch (m.name) {
				case MindMapMessages.FOCUS_MAP:
					onFocusMap(m);
					break;
			}
		}
		
		private function onFocusMap(m:Message):void {
			//Alert.show("Focus " + m.body.container.toString());
			var container:ViewContainer = ViewContainer(m.body.container);
			container.focus();
		}
		
		private function onMouseDown(event:MouseEvent):void {
			trace("CentralViewController.onMouseDown", event.target, event.currentTarget);
			if (event.target==event.currentTarget) {
				this.send(new Message(ApplicationMessages.FOCUS_IN, this));
			}
		}
	}
}