package mindmaps2.storage.services
{
	import collections.TreeCollectionEx;
	
	import converters.XmlCollectionConverter;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	
	import mf.framework.IResultResponder;
	
	import mindmaps.map.MapModel2;
	
	import vos.*;
	
	public class XmlMapLoader
	{
		private var responder:IResultResponder;
		private var loader:URLLoader;
		
		public function XmlMapLoader(responder:IResultResponder)
		{
			this.responder = responder;
		}

		public function load(path:String):void {
			var url:URLRequest = new URLRequest(path);
			loader = new URLLoader(url);
			loader.addEventListener("complete", mapLoaded);
		}
		
		private function mapLoaded(event:Event):void
		{
		    var mapXml:XML = XML(loader.data);
		    var map:MapModel2 = convertXml(mapXml);
		    responder.onResult("result", map);
		}
		
		private function convertXml(mapXml:XML):MapModel2 {
			var res:MapModel2 = new MapModel2(null);
			registerClassAlias("Item", Item);
			registerClassAlias("Note", Note);
			registerClassAlias("Task", Task);
			registerClassAlias("Appointment", Appointment);
			registerClassAlias("Contact", Contact);
			var nodes:TreeCollectionEx = new XmlCollectionConverter().fromXml(mapXml, new TreeCollectionEx());
			res.nodes = nodes;
			return res;
		}
	}
}