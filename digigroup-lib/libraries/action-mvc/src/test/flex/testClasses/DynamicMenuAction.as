package testClasses
{


	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.ActionType;
	import actions.LogicType;
	import actions.SuccessAlertAction;


	public class DynamicMenuAction extends AbstractIOAction
	{
		public function DynamicMenuAction(name:String=null)
		{
			super(name);
		}
		
		override protected function doExecute():void {
			var a1:AbstractAction = new SuccessAlertAction("task");
			var a2:AbstractAction = new SuccessAlertAction("note");
			var composite:AbstractAction = new AbstractIOAction();
			composite.type = ActionType.PARALLEL;
			composite.logicType = LogicType.OR;
			composite.addChildren([a1, a2]);
			this.parent.addChild(composite);
			composite.initialize();
			
			super.doExecute();
		}
	}
}