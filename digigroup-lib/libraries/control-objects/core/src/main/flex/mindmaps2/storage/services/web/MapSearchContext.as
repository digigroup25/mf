package mindmaps2.storage.services.web
{
	import mx.utils.UIDUtil;
	
	public class MapSearchContext
	{
		public var mapId:String;
		public var mapName:String;
		public function MapSearchContext(mapId:String=null, mapName:String=null)
		{
			if (mapId==null) //create random if not provided, webservice needs some id
				this.mapId = UIDUtil.createUID();
			else this.mapId=mapId;
			this.mapName=mapName;
		}
	}
}