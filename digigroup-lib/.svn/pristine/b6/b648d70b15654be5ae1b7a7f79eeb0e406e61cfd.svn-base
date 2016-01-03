package mf.framework
{
	import mx.collections.ArrayCollection;

	public class LoggingContainer extends Container2
	{
		public var incomingMessages:ArrayCollection = new ArrayCollection();
		
		public function LoggingContainer(mb:IMessageBroker=null, model:Object=null, controllers:Array=null, messageHandler:Function=null, containers:Array=null)
		{
			super(mb, model, controllers, messageHandler, containers);
		}
		
		override protected function doReceive(m:Message):void {
			incomingMessages.addItem(m);
			super.doReceive(m);
		}
	}
}