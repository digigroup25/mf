package mindmaps2.actions.element
{
	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.ActionEvent;
	import actions.ActionType;
	import actions.LogicType;
	
	import assertions.Require;
	import mindmaps2.actions.Actions;

	public class ActOnElementOrUnselect extends AbstractIOAction
	{
		public function ActOnElementOrUnselect(name:String=null)
		{
			super(name);
			super.type = ActionType.PARALLEL;
			super.logicType = LogicType.OR;
			
			this.preconditions = [checkPreconditions];
		}
		
		
		private function checkPreconditions():Boolean {
			Require.notNull(this.input.elementActions, "elementActions");
			Require.notNull(this.input.node, "node");
			
			return true;
		}
		
		override protected function doExecute():void {
			var elementActions:Array = this.input.elementActions as Array;
			//add actions
			this.addChildren(elementActions);
			this.addChild(new AbstractAction(Actions.UNSELECT_ELEMENT));
			
			for each (var action:AbstractAction in this.children) {
				addActionListeners(action);
				action.initialize();
			}
			
			
		}
		
		override protected function onChildActionCompleted(event:ActionEvent):void {
			super.onChildActionCompleted(event);
		}
		
	}
}