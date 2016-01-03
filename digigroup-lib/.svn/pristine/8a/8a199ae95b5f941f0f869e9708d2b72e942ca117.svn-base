package mf.framework.messaging
{
	import mf.framework.*;
	
	import mx.logging.errors.InvalidFilterError;
	
	[Deprecated]
	public class ExternalMessageAdapter implements IManagedLifecycle, IMessenger
	{
		public var internalMessageBroker:IMessageBroker;
		public var externalMessageBroker:IMessageBroker;
		public var inboundFilter:Object;
		public var outboundFilter:Object;
		private var internalReceiver:InternalMessageAdapter;
		private var initialized:Boolean = false;
		
		public function ExternalMessageAdapter(externalMessageBroker:IMessageBroker, internalMessageBroker:IMessageBroker, 
			inboundFilter:Object, outboundFilter:Object)
		{
			this.internalMessageBroker = internalMessageBroker;
			this.externalMessageBroker = externalMessageBroker;
			this.inboundFilter = inboundFilter;
			this.outboundFilter = outboundFilter;
		}
		
		public function initialize():void {
			if (initialized) return;
			
			internalReceiver = new InternalMessageAdapter(externalMessageBroker, internalMessageBroker,
				 outboundFilter);
			this.internalReceiver.initialize();
			this.externalMessageBroker.subscribe(this);
			
			initialized=true;
		}
		
		//receiving on outbound interface
		public function receive(m:Message):void {
			if (canForwardInboundMessage(m) && (!m.isForwarded)) {
				internalReceiver.send(m);
			}
		}
		
		public function send(m:Message, itself:Boolean=false):void {
			//mark as forwarded
			m.isForwarded=true;
			externalMessageBroker.send(m);
		}
		
		public function uninitialize():void {
			this.externalMessageBroker.unsubscribe(this);
			this.internalReceiver.uninitialize();
		}
		
		private function canForwardInboundMessage(m:Message):Boolean {
			if (inboundFilter is Boolean) return inboundFilter as Boolean;
			else if (inboundFilter is IMessageFilter) {
				return IMessageFilter(inboundFilter).canPass(m);
			}
			else throw new InvalidFilterError("invalid message filter: " + inboundFilter.toString());
		}
		
	}
	 
}

