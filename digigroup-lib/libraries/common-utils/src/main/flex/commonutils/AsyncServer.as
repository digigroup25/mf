package  commonutils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	public class AsyncServer
	{
		private var delay:uint=0; //delay in milliseconds
		private var timer:Timer;
		private var token:AsyncToken;
		
		private var responseGeneratorFunction:Function;
		private var responseGeneratorData:Object;
		
		public function AsyncServer(delay:uint=0)
		{
			this.delay = delay;
		}
		
		public function executeDelayedResponse(responseGeneratorFunction:Function, responseGeneratorData:Object=null):AsyncToken {
			token = new AsyncToken();
			timer = new Timer(delay);
			this.responseGeneratorFunction = responseGeneratorFunction;
			this.responseGeneratorData = responseGeneratorData;
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			return token;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			timer.stop();
			
			var response:Object = responseGeneratorFunction(this.responseGeneratorData);
			
			for each (var responder:IResponder in token.responders)
			{
				responder.result(new ResultEvent(ResultEvent.RESULT, false, true,
					response));
			}
		}
	}
}