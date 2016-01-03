package actions
{
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import actions.AbstractRepeatableAction;

	public class AbstractUserTestAction extends AbstractUserAction
	{
		public function AbstractUserTestAction(name:String="Execute Action", repeatCount:int=1)
		{
			super(name, repeatCount);
		}
		
		//TODO: VR 6/23/11 Investigate why needed to comment out, move action test classes to test packages under actionmvc
		/*protected override function doExecute():void {
			Alert.show("Execute action?", name,  Alert.YES|Alert.NO|Alert.NONMODAL, null, onClose);
		}*/
		
		private function onClose(e:CloseEvent):void {
			var userResult:uint = e.detail;
			if (userResult==Alert.YES) {
				super.doExecute();
			}
			else if (userResult==Alert.NO) {
				this.forceFailed();
			}
		}
	}
}