package mindmaps2.actions.map {
	import actions.AbstractUserAction;

	import assertions.Require;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;

	import mindmaps2.map.ui.MindMapMessages;

	public class CloseMap extends AbstractUserAction //implements IReceiver
	{

		public function CloseMap() {
			super("Close Map", 1);
			this.preconditions = [ checkPreconditions ];
			this.input.addAlias("invocationContainer", "mapContainer");
			this.input.addAlias("model", "map");
		}

		private var container:Container2;

		/* public function receive(m:Message):void {
			switch (m.name) {
				case TreeTabMessages.CLOSE_MAP_IN_TAB:
					onMapClose(m);
					break;
			}
		}

		private function onMapClose(m:Message):void {
			super.doExecute();
		} */

		override public function uninitialize():void {
			//container.mb.unsubscribe(this);
			super.uninitialize();
		}

		override protected function doExecute():void {
			container = Container2(this.input["mapContainer"]);
			/* container.mb.subscribe(this); */
			var map:MapModel2 = MapModel2(this.input["map"]);
			//container.send(new Message(TreeTabMessages.CLOSE_MAP_IN_TAB, this, {map:map}));
			container.send(new Message(MindMapMessages.CLOSE_MAP, this, { map: map }));

			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input["map"], "map");

			return true;
		}
	}
}
