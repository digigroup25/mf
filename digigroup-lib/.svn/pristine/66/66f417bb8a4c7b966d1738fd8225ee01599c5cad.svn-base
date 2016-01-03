package actions
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class FailAsyncAction extends AbstractAction
	{
		private var timer:Timer;
		private var time:int;
		
		public var result:String = "";
		
		public function FailAsyncAction(name:String="FailAsyncAction", time:int=100)
		{
			super(name);
			this.time = time;
		}
		
		protected override function doExecute():void {
			trace("FailAsyncAction.doExecute");
			timer = new Timer(time);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void {
			trace("FailAsyncAction.doExecute fail");
			timer.stop();
			this.fail();
		}
		
		protected override function doExecuteFail():void {
			result = "failed";
			super.doExecuteFail();
		}
	}
}