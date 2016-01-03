package mindmaps2.actions
{
	import actions.AbstractUserAction;

	public class UserTriggeredAction extends AbstractUserAction
	{
		public function UserTriggeredAction(name:String=null, repeatCount:int=1)
		{
			super(name, repeatCount);
		}
		
		override protected function doExecute():void {
			super.copyInputToOutput();
			super.doExecute();
		}
	}
}