package mindmaps2.actions.map
{
	import actions.AbstractUserAction;
	import actions.ActionType;
	import actions.LogicType;
	
	import mindmaps2.AppSettings;

	public class OpenMap extends AbstractUserAction
	{
		public function OpenMap(repeatCount:int=1/* AppSettings.DEFAULT_REPEAT_COUNT */)
		{
			super("openMap", repeatCount);
			this.type = ActionType.SEQUENTIAL;
			this.logicType = LogicType.AND;
			
			this.addChildren([new SelectMap2(), new DisplayMap()]);
		}
		
	}
}