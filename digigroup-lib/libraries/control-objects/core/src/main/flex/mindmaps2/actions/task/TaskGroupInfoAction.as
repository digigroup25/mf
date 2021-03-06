package mindmaps2.actions.task {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.elements.task.TaskMessages;

	public class TaskGroupInfoAction extends AbstractUserAction {
		public function TaskGroupInfoAction(name:String = "Info", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
		}

		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.mapContainer);
			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);
			Require.notNull(node, "node");

			var m:Message = new Message(TaskMessages.SHOW_GROUP_INFO, this, { node: node });
			container.send(m);

			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input.node, "node");
			return true;
		}
	}
}
