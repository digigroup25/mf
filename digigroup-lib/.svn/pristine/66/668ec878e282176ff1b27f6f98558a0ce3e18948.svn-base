package mindmaps.history
{
	import mf.framework.Message;
	import mf.framework.messaging.AbstractMessageFactory;
	
	import mindmaps.map.MapModel2;
	
	
	public class HistoryMessagesFactory extends AbstractMessageFactory
	{
		public function HistoryMessagesFactory(sender:Object)
		{
			super(sender);
		}
		
		public function ReplayAll(target:MapModel2, timeInterval:int=0):Message {
			return new Message(HistoryMessages.REPLAY_ALL_ACTIONS, sender, {target:target, timeInterval:timeInterval});
		}
		
		public function Replayed():Message {
			return new Message(HistoryMessages.REPLAYED_ACTION, sender);
		}
	}
}