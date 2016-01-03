package mindmaps2.ui
{
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	
	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.storage.MapStorageMessageFactory;

	public class ApplicationController extends AbstractController
	{
		private var storageMessages:MapStorageMessageFactory;
		
		public function ApplicationController(mb:IMessageBroker)
		{
			super(null, mb, null);
			storageMessages = new MapStorageMessageFactory(this);
		}
		
		/* override public function receive(m:Message):void {
			switch (m.name) {
				case MindMapMessages.SAVE_MAP: 
					onSaveMap(m);
					break;
			}
		} 
		
		private function onSaveMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body);
			var saveMap:Message = storageMessages.SaveMap(map);
			this.send(saveMap);
		} */
	}
}