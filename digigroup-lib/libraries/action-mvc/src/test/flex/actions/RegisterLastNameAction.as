package actions
{
	import components.*;
	
	import events.SubmitEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class RegisterLastNameAction extends AbstractUserAction
	{
		private var window:IFlexDisplayObject;
		public function RegisterLastNameAction(name:String=null)
		{
			super(name);
		}
		
		override protected function doExecute():void {
			window = new ComponentFactory().createInputBox("Last Name");
			PopUpManager.addPopUp(window, DisplayObject(Application.application));
			PopUpManager.centerPopUp(window);
			window.y += 80;
			window.addEventListener(SubmitEvent.SUBMIT, onSubmit);
			window.addEventListener(SubmitEvent.CANCEL, onCancel);
		}
		
		private function onSubmit(event:SubmitEvent):void {
			super.doExecute();
			PopUpManager.removePopUp(window);
		}
		
		private function onCancel(event:SubmitEvent):void {
			super.forceFailed();
			PopUpManager.removePopUp(window);
		}
		
		override protected function doExecuteFail():void {
			super.doExecuteFail();
			PopUpManager.removePopUp(window);
		}
	}
}