package mindmaps2.actions.element
{
	import actions.AbstractRepeatableAction;
	import actions.AbstractUserAction;
	
	import mindmaps2.AppSettings;
	import mindmaps2.actions.Actions;
	import mindmaps2.actions.UserTriggeredAction;

	public class SelectAndActOnElement extends AbstractRepeatableAction
	{
		public function SelectAndActOnElement(name:String=null, repeat:int=1)
		{
			super("selectAndActOnElement", AppSettings.INFINITE_REPEAT_COUNT);
			this.keepExecutingOrActions = true;
			
			var selectElement:AbstractUserAction = new UserTriggeredAction(Actions.SELECT_ELEMENT);

			this.addChildren([
				selectElement, 
				new CreateElementActions(), 
				new ActOnElementOrUnselect()
			]);
		}
		
	}
}