package mindmaps2.actions.task {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;

	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.elements.task.TaskMessageFactory;
	import mindmaps2.elements.task.TaskMessages;

	public class ExportDoneTasks extends AbstractUserAction implements IReceiver {
		public function ExportDoneTasks(name:String = "Export done", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
			this.taskMessages = new TaskMessageFactory(this);
		}

		private var container:Container2;

		private var taskMessages:TaskMessageFactory;

		public function receive(m:Message):void {
			switch (m.name) {
				case TaskMessages.EXPORTED_DONE:
					onExportedDoneTasks(m);
					break;
			}
		}

		override protected function doExecute():void {
			container = Container2(this.input.mapContainer);
			container.mb.subscribe(this); //subscribe to receive messages

			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);
			Require.notNull(node, "node");

			var m:Message = taskMessages.ExportDone(node);
			container.send(m);

		}

		private function onExportedDoneTasks(m:Message):void {
			container.mb.unsubscribe(this);
			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input.node, "node");
			return true;
		}
	}
}
