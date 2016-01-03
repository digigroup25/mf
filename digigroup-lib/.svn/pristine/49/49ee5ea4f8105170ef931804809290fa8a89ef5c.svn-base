package testClasses
{


	import actions.AbstractRepeatableAction;
	import actions.AbstractUserAction;
	import actions.ActionType;
	import actions.LogicType;
	import actions.SuccessAlertAction;


	public class RootAction extends AbstractRepeatableAction
	{
		public function RootAction(name:String=null)
		{
			super(name);
			this.type = ActionType.PARALLEL;
			
			this.addChild(new CreateSoftwareProjectAction());
			this.addChild(new NoOpAction("action1"));
			var dynamicMenuAction:AbstractUserAction = new AbstractUserAction("initialize menu");
			dynamicMenuAction.type=ActionType.SEQUENTIAL;
			dynamicMenuAction.logicType=LogicType.AND;
			var initMenuAction:AbstractUserAction = new SuccessAlertAction();
			dynamicMenuAction.addChildren([initMenuAction, new DynamicMenuAction()]);
			
			this.addChild(dynamicMenuAction);
		}
		
	}
}