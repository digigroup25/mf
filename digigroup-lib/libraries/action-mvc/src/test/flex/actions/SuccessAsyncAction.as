package actions
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SuccessAsyncAction extends AbstractAction
	{
		private var timer:Timer;
		private var time:int;
		public function SuccessAsyncAction(name:String="SuccessAsyncAction", time:int=100)
		{
			super(name);
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