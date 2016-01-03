package actions
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SuccessAsyncRepeatableAction extends AbstractRepeatableAction
	{
		private var timer:Timer;
		private var time:int;
		public function SuccessAsyncRepeatableAction(name:String="SuccessAsyncRepeatableAction", repeatCount:int=1, time:int=100)
		{
			super(name, repeatCount);
			this.time = time;
		}
		
		protected override function doExecute():void {
			timer = new Timer(time);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
		}
		
		private function onTimer(event:TimerEvent):void {
			timer.stop();
			this.setCompleted();
		}
	}
}