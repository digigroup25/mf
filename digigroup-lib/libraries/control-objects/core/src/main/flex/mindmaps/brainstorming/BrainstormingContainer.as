package mindmaps.brainstorming
{
	import components.InputTextLineWindow;
	
	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	
	public class BrainstormingContainer extends Container2
	{
		public function BrainstormingContainer(mb:IMessageBroker=null, model:Object=null, controllers:Array=null, messageHandler:Function=null, containers:Array=null)
		{
			var modelContainer:Container2 = new Container2(mb, model);
				//[new InputQueueController()]);
			var viewContainer:Container2 = new Container2(mb, new InputTextLineWindow(),
				[new BrainstormingWindowController()]);
			this.containers = [modelContainer, viewContainer];
			super(mb, model, null, null, this.containers);
		}
		
	}
} 