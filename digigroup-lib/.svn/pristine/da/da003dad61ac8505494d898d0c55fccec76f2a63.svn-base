package actions
{
	public class FailSyncAction extends AbstractAction
	{
		public var result:String = "not done";
		
		public function FailSyncAction(name:String="FailSyncAction") {
			super(name);
		}
		
		protected override function doExecute():void {
			result = "executing";
			this.fail();
		}
		
		protected override function doExecuteFail():void {
			result = "failed";
			super.doExecuteFail();
		}
	}
}