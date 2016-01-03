package mindmaps2.actions.element {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps.map.messages.NodeMessages;

	import mindmaps2.map.ui.MindMapMessages;

	public class ImportElement extends AbstractUserAction {
		public function ImportElement(name:String = "Import", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
		}

		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.mapContainer);
			var node:TreeCollectionEx = TreeCollectionEx(this.input.node);
			var m:Message = new Message(NodeMessages.IMPORT_NODE, this, { node: node });
			container.send(m);
			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.instanceOf(this.input.node, TreeCollectionEx, "node");
			return true;
		}
	}
}
