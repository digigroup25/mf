package mindmaps2.actions.iteration {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps2.elements.iteration.IterationMessages;

	public class IterationStatusAction extends AbstractUserAction {
		public function IterationStatusAction(name:String = "Status", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
		}

		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.mapContainer);
			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);

			var m:Message = new Message(IterationMessages.SHOW_ITERATION_STATUS, this, { node: node });
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
