package actions
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;


	public class ActionTestCase
	{
		protected var resultCheckTimer:Timer;
		private static const TIMEOUT_MS:int = 350;
		private static const RESULT_CHECK_TIMEOUT_MS:int = 350;
		protected var events:Array;
		protected var a:AbstractAction;


		[Before]
		public function setUp():void
		{
			resultCheckTimer = new Timer(TIMEOUT_MS);
			events = new Array();
		}


		protected function executeAction(action:AbstractAction, checkHandler:Function, factoryObject:Object):void
		{
			//start execution
			action.addEventListener(ActionEvent.STATUS_CHANGE, addEventToEventQueue);
			action.initialize();
			executeInitializedAction(action, checkHandler, factoryObject);
		}


		protected function executeInitializedAction(action:AbstractAction, checkHandler:Function,
													factoryObject:Object):void
		{
			resultCheckTimer.addEventListener(TimerEvent.TIMER, Async.asyncHandler(this, checkHandler, RESULT_CHECK_TIMEOUT_MS, factoryObject));
			resultCheckTimer.start();

			action.execute();
		}


		protected function addEventToEventQueue(event:ActionEvent):void
		{
			this.events.push(event);
		}


		protected function clearEventQueue():void
		{
			this.events = new Array();
		}


		protected function assertStatus(action:AbstractAction, status:String):void
		{
			assertEquals(action.toString(), status, action.status);
		}


		protected function selfValidate(event:Event, token:Object):void
		{
			token.validate(token, events);
		}


		protected function executeFactoryObject(factoryObject:Object, checkHandler:Function):void
		{
			var action:AbstractAction = AbstractAction(factoryObject.result);
			executeAction(action, checkHandler, factoryObject);
		}

	}
}