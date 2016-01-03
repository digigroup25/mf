package mindmaps2.storage.services.web
{
	public class ResponseParser
	{
		import mx.rpc.events.*;
	
		public function parse(data:Object):ResponseContext
		{
			var e:ResultEvent = data as ResultEvent;
			var success:Boolean = e.result.success;
			var message:String;
			if (!success)
				message = e.result.message;
				
			var result:ResponseContext = new ResponseContext(success, message);
			return result;
		}
	}
}