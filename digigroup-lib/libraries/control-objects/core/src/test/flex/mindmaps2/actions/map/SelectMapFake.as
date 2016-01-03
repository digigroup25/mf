package mindmaps2.actions.map
{
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;
	
	import mindmaps2.storage.MapStorageMessages;
	
	public class SelectMapFake extends SelectMap
	{
		public function SelectMapFake()
		{
		}
		
		override protected function doExecute():void {
			//var map:MapModel2 = new MapModel2Factory().createPriorityMap();
			var map:MapModel2 = new MapModel2Factory().createRandomMaps(1, 20)[0];//PriorityMap();
			this.output.map = map;
			super.forceComplete();//doExecute();
			
			/* var map:MapModel2 = new MapModel2Factory().createPriorityMap();
			var m:Message = new Message(MapStorageMessages.LOADED_MAP, this, {map:map});
			this.container.send(m); */
		}
	}
}