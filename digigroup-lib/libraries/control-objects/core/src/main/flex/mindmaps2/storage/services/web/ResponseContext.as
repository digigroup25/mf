package mindmaps2.storage.services.web
{
	public class ResponseContext
	{
		public var success:Boolean;
		public var message:String;
		
		public function ResponseContext(success:Boolean, message:String)
		{
			this.success = success;
			this.message = message;
		}
	}
}