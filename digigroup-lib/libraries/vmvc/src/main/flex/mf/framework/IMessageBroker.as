package mf.framework
{
	import mf.framework.messaging.Connector;
	
	public interface IMessageBroker extends ISender, IObserver//, IUninitialize
	{
		function get connectors():Array;
		function get numConnectors():int;
		function connect(mb:IMessageBroker, inboundFilter:Object=true, outboundFilter:Object=true):void;
		function disconnect(mb:IMessageBroker):void;
		function disconnectAll():void;
		function addConnector(connector:Connector):void;
		function removeConnector(connector:Connector):void;
	}
}