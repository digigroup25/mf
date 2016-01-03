package mindmaps2.storage.services.web
{
	import mx.collections.ArrayCollection;
	
	public class GetMapsResponseContext extends ResponseContext
	{
		public var maps:ArrayCollection;
		
		public function GetMapsResponseContext(context:ResponseContext)
		{
			super(context.success, context.message);
		}
	}
}