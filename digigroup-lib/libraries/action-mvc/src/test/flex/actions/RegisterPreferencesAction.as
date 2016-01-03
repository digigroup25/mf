package actions
{
	import components.*;
	
	import events.SubmitEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class RegisterPreferencesAction extends AbstractUserAction
	{
		private var window:IFlexDisplayObject;
		public function RegisterPreferencesAction(name:String=null)
		{
			super(name);
		}
		
		override protected function doExecute():void {
			window = new ComponentFactory().createInputBox("Preferences");
			PopUpManager.addPopUp(window, DisplayObject(Application.application));
			PopUpManager.centerPopUp(window);
			window.x += 80;
			window.addEventListener(SubmitEvent.SUBMIT, onSubmit);
			window.addEventListener(SubmitEvent.CANCEL, onCancel);
		}
		
		private function onSubmit(event:SubmitEvent):void {
			PopUpManager.removePopUp(window);
			super.doExecute();
		}
		
		private function onCancel(event:SubmitEvent):void {
			super.forceFailed();
		}
		
		override protected function doExecuteFail():void {
			PopUpManager.removePopUp(window);
			super.doExecuteFail();
		}
	}
}