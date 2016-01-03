package actions
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexunit.framework.TestCase;

	import org.flexunit.async.Async;


	public class AsyncActionExecutor
	{
		private var resultCheckTimer:Timer;
		private static const TIMEOUT_MS:int = 350;
		private static const RESULT_CHECK_TIMEOUT_MS:int = 350;
		private var events:Array;
		
		private var checkHandler:Function;
		

		public function initialize():void {
			resultCheckTimer = new Timer(TIMEOUT_MS);
        	events = new Array();
		}

		public function uninitialize():void {
			resultCheckTimer.stop();
			resultCheckTimer.removeEventListener(TimerEvent.TIMER, checkHandler);
			resultCheckTimer = null;
			events = null;
		}
		
		public function executeAction(action:AbstractAction, checkHandler:Function, factoryObject:Object):void {
			this.checkHandler = checkHandler;
			resultCheckTimer.addEventListener(TimerEvent.TIMER, Async.asyncHandler(this, checkHandler, RESULT_CHECK_TIMEOUT_MS));
          	resultCheckTimer.start();

			//start execution
			action.addEventListener(ActionEvent.STATUS_CHANGE, onStatusChange);
			action.initialize();
			action.execute();
		}
		
		private function onStatusChange (event:ActionEvent):void {
			this.events.push(event);
		}
		
		public function getEvents():Array {
			return this.events;
		}
		
		public function clearEvents():void {
			this.events = new Array();
		}
	}
}