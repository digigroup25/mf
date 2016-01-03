package mindmaps2.actions.map
{
	import actions.AbstractIOAction;
	
	import messages.Messages;
	
	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;
	
	import mindmaps.map.MapModel2;
	
	import mindmaps2.storage.MapStorageMessageFactory;
	import mindmaps2.storage.MapStorageMessages;

	[Deprecated]
	public class SelectMap extends AbstractIOAction implements IReceiver
	{
		private var storageMessages:MapStorageMessageFactory;
		protected var container:Container2;
		
		public function SelectMap()
		{
			super("selectMap");
			storageMessages = new MapStorageMessageFactory(this);
		}
		
		override protected function doExecute():void {
			container = this.input.invocationContainer;
			container.mb.subscribe(this);
			
			var m:Message = storageMessages.ShowWindow();
			container.send(m);
		}
		
		protected override function doExecuteFail():void {
			closeMapStorageWindow();
			super.doExecuteFail();
		}
		
		private function closeMapStorageWindow():void {
			var m:Message = storageMessages.HideWindow();
			container.send(m);
		}
		
		public function receive(m:Message):void {
			switch (m.name) {
				case MapStorageMessages.GOT_MAP:
					onLoadedMap(m);
					break;
				case Messages.CANCEL:
					onCancel(m);
					break;
			}
		}
		
		private function onLoadedMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			this.output.map = map;
			
			closeMapStorageWindow();
			super.doExecute();
		}
		
		private function onCancel(m:Message):void {
			this.fail();
		}
	}
}