package testclasses
{


	import mindmaps2.storage.services.ServiceLocator;

	import mx.rpc.*;
	import mx.rpc.events.*;
	import mx.rpc.soap.WebService;


	public class TestMapServiceDelegate implements IResponder
	{
		private var responder:IResponder;
		private var service:*;
		
		public var resultCallback:Function;
		
		public function TestMapServiceDelegate(/*responder:IResponder*/):void
		{
			//this.responder = responder;	
			var sl:ServiceLocator = ServiceLocator.getInstance();
			//this.service = sl.getWebService(ControlConfiguration.mapServiceName);
			var ws:WebService = new WebService();
			ws.wsdl = "http://localhost:2732/MindFactoryService/TestMapService.asmx?wsdl";
			ws.loadWSDL();
			//var o:Operation = new Operation(ws, "GetXml");
			//o.resultFormat = "xml";
			this.service = ws;
		}
		
		public function createConfig1():void
		{
			var token:AsyncToken = service.CreateMaps_Config1();
        	token.addResponder(this);	
		}
		
		public function clearMaps():void
		{
            var token:AsyncToken = service.ClearMaps();
        	token.addResponder(this);	
		}
		
		public function createMap_v1():void
		{
            var token:AsyncToken = service.CreateMap_v1();
        	token.addResponder(this);	
		}
		
		public function getXml():void
		{
            var token:AsyncToken = service.GetXml();
        	token.addResponder(this);	
		}
		
		public function storeXml(xml:XML):void
		{
            var token:AsyncToken = service.StoreXml(xml);
        	token.addResponder(this);	
		}
		
		public function result(data:Object):void
		{
			if (resultCallback!=null)
			{
				var e:ResultEvent = data as ResultEvent;
				//var bodyXml:XML = new XML(e.message.body);// result.xmlDoc);
				var res:XML;
				//var res:XML = bodyXml.body.GetXmlResponse.GetXmlResult.xmlDoc[0];
				resultCallback(res.toXMLString());
			}
		}
	
		public function fault(info:Object):void
		{
			var e:FaultEvent = FaultEvent(info);
			//responder.fault(e.fault.message);
		}
		
	}
}