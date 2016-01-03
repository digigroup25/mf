package mindmaps2.actions.map
{
	import actions.AbstractUserAction;
	
	import mf.framework.Container2;
	import mf.framework.Message;
	
	import mindmaps.map.ui.actions.messages.MapMessages;

	public class ShowMapDirectory extends AbstractUserAction
	{
		public function ShowMapDirectory(name:String=null, repeatCount:int=1)
		{
			super("showMapDirectory", repeatCount);
			this.userInvocationOnly = true;
		}
		
		
		override protected function doExecute():void {
			var container:Container2 = Container2(this.input.invocationContainer);
			var m:Message = new Message(MapMessages.OPEN_MAP_DIRECTORY, this); 
			container.send(m);
			super.doExecute();
		}		
	}
}