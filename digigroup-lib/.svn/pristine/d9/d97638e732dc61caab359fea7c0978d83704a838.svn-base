package mindmaps2.ui
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.PopUpMenuButton;
	
	public class PopUpMenuButtonEx extends PopUpMenuButton
	{
		public function PopUpMenuButtonEx()
		{
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			if (event.keyCode==Keyboard.SPACE)
				return;
			super.keyDownHandler(event);
		}
	}
}