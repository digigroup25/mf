package actions
{
	public class SuccessSyncAction extends AbstractAction
	{
		
		public var result:String = "not done";
		
		public function SuccessSyncAction(name:String="SingleSuccessAction") {
			super(name);
		}
		
		protected override function doExecute():void {
			result = "done";
			this.setCompleted();
		}
	}
}