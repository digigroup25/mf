package mf.framework.messaging
{
	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;

	public class ControllerFake extends AbstractController
	{
		public function ControllerFake(modelProvider:IModelProvider=null, mb:IMessageBroker=null, messageHandler:Function=null)
		{
			super(modelProvider, mb, messageHandler);
		}
		
	}
}