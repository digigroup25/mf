package mf.framework
{
	public class MessageMacroCommand extends AsyncCommand implements ISender
	{
		internal var mb:IMessageBroker;
		public function MessageMacroCommand()
		{
		}
		

		public function send (m:Message, itself:Boolean=false):void {
			mb.send(m, itself);
		}
	}
}