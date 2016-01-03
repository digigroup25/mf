package mindmaps2.actions.element {
	import actions.AbstractUserAction;

	import assertions.Require;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps2.map.ui.MindMapMessages;

	public class ExpandDescendants extends AbstractUserAction {
		public function ExpandDescendants(name:String = "Expand", repeatCount:int = 1) {
			super(name, repeatCount);
			this.preconditions = [ checkPreconditions ];
		}

		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.mapContainer);
			var m:Message = new Message(MindMapMessages.EXPAND_DESCENDANTS, this);
			container.send(m);
			super.doExecute();
		}

		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");

			return true;
		}
	}
}
