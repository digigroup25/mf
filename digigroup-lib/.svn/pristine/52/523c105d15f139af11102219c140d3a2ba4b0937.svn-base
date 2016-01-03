package mf.framework.messaging
{
	import mf.framework.*;
	
	import mx.logging.errors.InvalidFilterError;
	
	[Deprecated]
	internal class InternalMessageAdapter implements IMessenger, IManagedLifecycle
	{
		
		private var externalInterface:IMessageBroker;
		private var internalInterface:IMessageBroker;
		private var outboundFilter:Object;
		
		public function InternalMessageAdapter(externalMessageBroker:IMessageBroker,
			internalMessageBroker:IMessageBroker, outboundFilter:Object)
		{
			this.externalInterface = externalMessageBroker;
			this.internalInterface = internalMessageBroker;
			this.outboundFilter = outboundFilter;
		}
		
		//MessageAdapter manager subscribing this to internal message broker
		public function initialize():void {
			this.internalInterface.subscribe(this);
		}
		
		public function uninitialize():void {
			this.internalInterface.unsubscribe(this);
		}
		
		//forward outbound if allowed
		public function receive(m:Message):void {
			if (canForwardOutboundMessage(m) && (!m.isForwarded))
				externalInterface.send(m);
		}
		
		public function send(m:Message, itself:Boolean=false):void {
			m.isForwarded = true;
			internalInterface.send(m);
		}
		
		private function canForwardOutboundMessage(m:Message):Boolean {
			if (outboundFilter is Boolean) return outboundFilter as Boolean;
			else if (outboundFilter is IMessageFilter) {
				return IMessageFilter(outboundFilter).canPass(m);
			}
			else throw new InvalidFilterError("invalid filter: " + outboundFilter.toString());
		}
	}
}