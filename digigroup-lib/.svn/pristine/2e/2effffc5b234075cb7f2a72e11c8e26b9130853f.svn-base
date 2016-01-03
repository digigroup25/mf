package mf.framework.messaging
{
	import mf.framework.Message;
	
	internal class ExcludeMessageFilter implements IMessageFilter
	{
		private var messages:Array = [];
		public function ExcludeMessageFilter( messages:Array)
		{
			if (messages!=null)
				this.messages = this.messages.concat(messages);
		}
		
		public function canPass(message:Message):Boolean {
			for each (var messageType:String in messages) {
				if (message.name==messageType) 
					return false;
			}
			return true;
		}
	}
}