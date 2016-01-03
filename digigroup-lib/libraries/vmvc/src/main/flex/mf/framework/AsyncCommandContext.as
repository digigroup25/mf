package mf.framework
{
	import mx.rpc.AsyncResponder;
	
	public class AsyncCommandContext extends CommandContext
	{
		public var responder:AsyncResponder;
		
		public function AsyncCommandContext(message:Message, model:Object, responder:AsyncResponder)
		{
			super(message, model);
			this.responder = responder;
		}

	}
}