package mf.framework
{
	public class Receiver implements IReceiver
	{
		private var messageHandler:Function;
		
		public function Receiver(messageHandler:Function)
		{
			this.messageHandler = messageHandler;
		}

		public function receive(message:Message):void
		{
			messageHandler(message);
		}
		
	}
}