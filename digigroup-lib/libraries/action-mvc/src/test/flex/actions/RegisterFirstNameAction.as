package actions
{
	import components.*;
	
	import events.SubmitEvent;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class RegisterFirstNameAction extends AbstractUserAction
	{
		private var window:InputDataBox;
		private var timer:Timer;
		public function RegisterFirstNameAction(name:String=null)
		{
			super(name);
		}
		
		override protected function doExecute():void {
			window = new ComponentFactory().createInputBox("First Name");
			PopUpManager.addPopUp(window, DisplayObject(Application.application));
			PopUpManager.centerPopUp(window);
			window.y -= 80;
			window.addEventListener(SubmitEvent.SUBMIT, onSubmit);
			window.addEventListener(SubmitEvent.CANCEL, onCancel);
		}
		
		override protected function doExecuteFail():void {
			timer = new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER, onAbortTimer);
			timer.start();
			if (window) window.status.text = "Aborting...";
		}
		
		private function onAbortTimer(event:TimerEvent):void {
			timer.stop();
			PopUpManager.removePopUp(window);
			super.setFailed();
		}
		
		private function onSubmit(event:SubmitEvent):void {
			PopUpManager.removePopUp(window);
			super.doExecute();
		}
		
		private function onCancel(event:SubmitEvent):void {
			super.forceFailed();
			PopUpManager.removePopUp(window);
		}
	}
}