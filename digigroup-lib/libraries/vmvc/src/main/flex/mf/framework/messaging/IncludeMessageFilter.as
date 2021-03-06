package mf.framework.messaging
{
	import mf.framework.Message;
	
	public class IncludeMessageFilter implements IMessageFilter
	{
		private var messages:Array = [];
		public function IncludeMessageFilter(messages:Array)
		{
			if (messages!=null)
				this.messages = this.messages.concat(messages);
		}
		
		public function canPass(message:Message):Boolean {
			for each (var messageType:String in messages) {
				if (message.name==messageType) 
					return true;
			}
			return false;
		}
	}
}