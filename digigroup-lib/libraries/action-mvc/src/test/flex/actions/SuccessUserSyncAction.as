package actions
{
	public class SuccessUserSyncAction extends AbstractUserAction
	{
		public var result:String = "not done";
		
		public function SuccessUserSyncAction(name:String="SuccessUserSyncAction",
			repeatCount:int=1)
		{
			super(name, repeatCount);
		}
		
		protected override function doExecute():void {
			result = "done";
			super.doExecute();
		}
	}
}