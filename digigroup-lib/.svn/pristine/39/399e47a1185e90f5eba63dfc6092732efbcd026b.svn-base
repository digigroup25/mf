package mindmaps2.storage.services.web
{
	import commonutils.*;
	
	import mindmaps2.storage.PersistentMap;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.*;
	
	public class GetMapsResponseParser
	{
		public function parse(data:Object):GetMapsResponseContext
		{
			var e:ResultEvent = data as ResultEvent;
			var maps:ArrayCollection=new ArrayCollection();
			var rc:ResponseContext = new ResponseParser().parse(data);
			var result:GetMapsResponseContext = new GetMapsResponseContext(rc);
			result.maps = maps;
			if (!result.success)
				return result;
			var res:*; 
			if (!e.result.hasOwnProperty("result"))
				return result;
			else
				res = e.result.result;
			var m:PersistentMap;
			if (res is ArrayCollection)
				for each (var r:* in res)
				{
					m = parseMap(r);
					maps.addItem(m);
				}
			else
			{
				m = parseMap(res);
				maps.addItem(m);
			}
			return result;
		}
		
		public function parseMap(r:*):PersistentMap
		{
			var map:PersistentMap = new PersistentMap();
			map.id = r.id;
			map.name = r.name;
			map.version = r.version;
			map.isPrivate = r.isPrivate;
			map.lastModified = r.lastModified;
			if (r.hasOwnProperty("mapData"))
				map.mapData = Base64.decode(r.mapData);
			return map;
		}
	}
}