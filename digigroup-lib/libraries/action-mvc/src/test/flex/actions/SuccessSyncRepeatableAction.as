package actions
{
	public class SuccessSyncRepeatableAction extends AbstractRepeatableAction
	{
		public function SuccessSyncRepeatableAction(name:String="SuccessSyncRepeatableAction", repeatCount:int=2) {
			super(name, repeatCount);
		}
		
		protected override function doExecute():void {
			this.setCompleted();
		}
	}
}