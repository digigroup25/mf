package mf.framework
{
	import mx.collections.ArrayCollection;
	
	public class LoggingReceiver extends Receiver
	{
		public var loggedMessages:ArrayCollection = new ArrayCollection();
		
		public function get numMessages():int {
			return loggedMessages.length;
		}
		
		public function LoggingReceiver()
		{
			super(receive);
		}
		
		override public function receive(message:Message):void {
			loggedMessages.addItem(message);
		}
		
		public function clear():void {
			loggedMessages = new ArrayCollection();
		}
	}
}