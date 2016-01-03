package mf.framework
{
	import mx.collections.ArrayCollection;
	
	public class MessageLogBroker extends MessageBroker implements IMessageBroker
	{
		public var log:ArrayCollection = new ArrayCollection();

		public function MessageLogBroker()
		{
		}

		override public function send(m:Message, itself:Boolean=false):void
		{
			log.addItem(m);
			super.send(m, itself);
		}
		
		public function get logSize():int {
			return log.length;
		}
		
		public function get numMessages():int {
			return log.length;
		}
		
		public function clearLog():void {
			log.removeAll();
		}
	}
}