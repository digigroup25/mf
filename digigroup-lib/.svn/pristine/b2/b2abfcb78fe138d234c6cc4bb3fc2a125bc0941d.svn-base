package mindmaps2.actions.map {
	import actions.AbstractAction;
	import actions.AbstractIOAction;

	import flash.display.DisplayObjectContainer;

	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;
	import mf.framework.ViewContainer;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.tree.messages.TreeTabMessageFactory;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;

	import mindmaps2.storage.MapStorageMessages;

	public class DisplayMap extends AbstractIOAction implements IReceiver {

		public function DisplayMap() {
			super("displayMap");
		}

		private var container:Container2;

		private var mapStorageContainer:Container2;

		public function receive(m:Message):void {
			switch (m.name) {
				case MapStorageMessages.GOT_MAP:
					onGotMap(m);
					break;
				case TreeTabMessages.TAB_CREATED:
					onMapInTabOpened(m);
					break;
			}
		}

		override public function uninitialize():void {
			container.mb.unsubscribe(this);
			super.uninitialize();
		}

		override protected function doExecute():void {
			container = Container2(this.input.invocationContainer);
			container.mb.subscribe(this);
		}

		private function get parentContainer():DisplayObjectContainer {
			return DisplayObjectContainer(ViewContainer(this.input.invocationContainer).view);
		}

		private function onGotMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			mapStorageContainer = Container2(m.body.mapStorageContainer);
			initializeMapContainer(map);
		}

		private function onMapInTabOpened(m:Message):void {
			var mapContainer:Container2 = Container2(m.body.container);
			this.output.mapContainer = mapContainer;
			this.output.mapStorageContainer = mapStorageContainer;
			this.output.map = MapModel2(m.body.model);

			container.mb.unsubscribe(this); //unsubscribe to not receive loaded map messages
			super.doExecute();
		}

		private function initializeMapContainer(map:MapModel2):void {
			var messageFactory:TreeTabMessageFactory = new TreeTabMessageFactory(container);
			container.send(messageFactory.createOpenMap(map, AbstractAction(this.parent)));
		}
	}
}
