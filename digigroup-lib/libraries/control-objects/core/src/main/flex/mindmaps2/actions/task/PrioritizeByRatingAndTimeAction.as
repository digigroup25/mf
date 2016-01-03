package mindmaps2.actions.task {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.elements.task.TaskMessages;

	public class PrioritizeByRatingAndTimeAction extends AbstractUserAction {
		public function PrioritizeByRatingAndTimeAction(name:String = "Prioritize by rating and time", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
		}

		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.mapContainer);
			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);
			Require.notNull(node, "node");

			var m:Message = new Message(TaskMessages.PRIORITIZE, this, { node: node, fieldName: "ptRatio" });
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
