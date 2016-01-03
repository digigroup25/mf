package mindmaps2.storage.services.web
{
	import mx.controls.Alert;
	
	public class ResponseHandler
	{
		public function handleResponse(response:ResponseContext):Boolean
		{
			if (!response.success)
			{
				Alert.show("Error: "+response.message);
			}
			return response.success;
		}
	}
}