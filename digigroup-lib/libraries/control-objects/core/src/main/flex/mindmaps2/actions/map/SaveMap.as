package mindmaps2.actions.map {
	import actions.AbstractUserAction;

	import assertions.Require;

	import logging.LogUtil;

	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;

	import mindmaps2.AppSettings;
	import mindmaps2.storage.MapStorageMessageFactory;
	import mindmaps2.storage.MapStorageMessages;

	import mx.logging.ILogger;
	import mx.managers.CursorManager;

	public class SaveMap extends AbstractUserAction implements IReceiver {

		private static const logger:ILogger = LogUtil.getLogger(SaveMap);

		public function SaveMap() {
			super("Save Map", AppSettings.DEFAULT_REPEAT_COUNT);
			this.storageMessages = new MapStorageMessageFactory(this);
			this.preconditions = [ checkPreconditions ];

			this.input.addAlias("model", "map");
		}

		private var container:Container2;

		private var storageMessages:MapStorageMessageFactory;

		private var startTime:Date;

		public function receive(m:Message):void {
			switch (m.name) {
				case MapStorageMessages.SAVED_MAP:
					onSavedMap(m);
					break;
			}
		}

		override protected function doExecute():void {
			startTime = new Date();
			container = Container2(this.input.mapStorageContainer);
			container.mb.subscribe(this);
			var map:MapModel2 = MapModel2(this.input.map);

			CursorManager.setBusyCursor();
			var m:Message = storageMessages.SaveMap(map);
			container.send(m);


		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapStorageContainer, "mapStorageContainer");
			Require.notNull(this.input.map, "map");

			return true;
		}

		private function onSavedMap(m:Message):void {
			logger.debug("Saving a map took {0} s", (new Date().time - startTime.time) / 1000);
			CursorManager.removeBusyCursor();

			container.mb.unsubscribe(this);
			super.doExecute();
		}
	}
}
