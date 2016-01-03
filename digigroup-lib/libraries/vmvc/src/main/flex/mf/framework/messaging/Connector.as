package mf.framework.messaging
{
	import mf.framework.IManagedLifecycle;
	import mf.framework.IMessageBroker;
	import mf.framework.IReceiver;
	import mf.framework.Message;
	import mf.framework.Receiver;
	
	import mx.logging.errors.InvalidFilterError;
	
	public class Connector implements IManagedLifecycle
	{
		private var mbA:IMessageBroker;
		private var mbB:IMessageBroker;
		private var abFilter:Object;
		private var baFilter:Object;
		private var aReceiver:IReceiver;
		private var bReceiver:IReceiver;
		
		public function Connector(mbA:IMessageBroker, mbB:IMessageBroker, abFilter:Object,
			baFilter:Object)
		{
			this.mbA = mbA;
			this.mbB = mbB;
			this.abFilter = abFilter;
			this.baFilter = baFilter;
			
			aReceiver = new Receiver(receiveFromA);
			bReceiver = new Receiver(receiveFromB);
			
		}
		
		public function isConnectedTo(mb:IMessageBroker):Boolean {
			return (mb==mbA || mb==mbB);
		}
		
		public function initialize():void {
			mbA.subscribe(aReceiver);
			mbB.subscribe(bReceiver);
			
			mbA.addConnector(this);
			mbB.addConnector(this);
		}
		
		public function uninitialize():void {
			mbA.unsubscribe(aReceiver);
			mbB.unsubscribe(bReceiver);
			
			mbA.removeConnector(this);
			mbB.removeConnector(this);
		}
		
		private function receiveFromA(m:Message):void {
			if (canForwardMessage(m, abFilter) && (!m.isForwarded)) {
				m.isForwarded = true;
				mbB.send(m);
			}
		}
		
		private function receiveFromB(m:Message):void {
			if (canForwardMessage(m, baFilter) && (!m.isForwarded)) {
				m.isForwarded = true;
				mbA.send(m);
			}
		}
		
		private function canForwardMessage(m:Message, filter:Object):Boolean {
			if (filter is Boolean) return filter as Boolean;
			else if (filter is IMessageFilter) {
				return IMessageFilter(filter).canPass(m);
			}
			else throw new InvalidFilterError("invalid message filter: " + filter.toString());
		}
	}
}