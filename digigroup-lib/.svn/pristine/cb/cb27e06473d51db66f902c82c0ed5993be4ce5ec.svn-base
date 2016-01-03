package mf.framework
{
	import mf.framework.messaging.Connector;
	
	public class MessageBroker implements IMessageBroker
	{
		public var subscribers:Array;
		public static var count:int = 0;
		protected var id:int;
		
		private var _connectors:Array = [];
		
		public function get connectors():Array {
			return _connectors;
		}
		
		public function get numConnectors():int {
			return _connectors.length;
		}
		
		public function MessageBroker()
		{
			subscribers = new Array();
			
			count++;
			id = count;
		}
		
		public function subscribe(subscriber:IReceiver):void
		{
			if (this.hasSubscriber(subscriber))
				return;
			subscribers.push(subscriber);
		}
		
		public function unsubscribe(subscriber:IReceiver):void
		{
			var index:int = this.subscribers.indexOf(subscriber);
			if (index!=-1)
				subscribers.splice(index, 1);
		}
		
		public function send(m:Message, itself:Boolean=false):void
		{
			for each (var receiver:IReceiver in subscribers)
			{
				if (!m.isActive())
					break; //don't send the message anywhere if it is not in active status 
				if (!itself) {
					if (receiver==m.sender) continue; //ignore sender
				}
				receiver.receive(m);
			}
		}
		
		public function hasSubscriber(subscriber:IReceiver):Boolean {
			return this.subscribers.indexOf(subscriber)!=-1;
		}
		
		public function connect(mb:IMessageBroker, inboundFilter:Object=true, outboundFilter:Object=true):void {
			if (this==mb)
				return;
			var connector:Connector = getConnectorTo(mb);
			if (connector!=null)
				return;
			connector = new Connector(this, mb, inboundFilter, outboundFilter);
			connector.initialize();
		}
		
		public function addConnector(connector:Connector):void {
			if (this.connectors.indexOf(connector)!=-1)
				return;
			connectors.push(connector);
		}
		
		public function removeConnector(connector:Connector):void {
			var connectorIndex:int = this.connectors.indexOf(connector);
			if (connectorIndex==-1)
				return;
			connectors.splice(connectorIndex, 1);
		}
		
		public function disconnect(mb:IMessageBroker):void {
			var connector:Connector = getConnectorTo(mb);
			if (connector==null)
				return;
			
			connector.uninitialize();
		}
		
		public function disconnectAll():void {
			while(connectors.length>0) {
				var connector:Connector = Connector(connectors.shift());
				connector.uninitialize();
			}
		}
		
		private function getConnectorTo(mb:IMessageBroker):Connector {
			for each (var connector:Connector in this.connectors) {
				if (connector.isConnectedTo(mb))
					return connector;
			}
			return null;
		}
		/* public function uninitialize():void {
			while (subscribers.length>0) subscribers.pop();
			subscribers=null;
		} */
	}
}