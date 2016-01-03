package mf.framework
{
	import mx.controls.Label;

	public class MockViewContainerDecorator extends ViewContainerDecorator
	{
		public var messagesReceived:Array = [];
		
		public function MockViewContainerDecorator(mb:MessageBroker)
		{
			var container:Container2 = new Container2(mb, null, null, handleMessage);
			super(container, new Label());
		}
		
		private function handleMessage(m:Message):void {
			messagesReceived.push(m);
		}
	}
}