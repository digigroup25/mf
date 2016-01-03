package mf.framework
{
	import mx.collections.ArrayCollection;
	
	public class MessageTraceBroker extends MessageBroker implements IMessageBroker
	{
		override public function send(m:Message, itself:Boolean=false):void
		{
			trace("mbid: "+this.id, m);
			super.send(m, itself);
		}

	}
}