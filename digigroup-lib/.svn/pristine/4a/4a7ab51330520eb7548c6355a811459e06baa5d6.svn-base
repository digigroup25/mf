package actions
{
	import mx.controls.Alert;
	
	public class SuccessAlertAction extends AbstractUserAction
	{
		public function SuccessAlertAction(name:String=null)
		{
			super(name);
		}
		
		protected override function doExecute():void {
			Alert.show("Completed "+name);
			this.setCompleted();
		}
	}
}