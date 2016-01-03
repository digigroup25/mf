package mf.framework
{
	import actions.AbstractAction;
	
	import flash.events.Event;

	public class ActionContainerDecoratorEvent extends Event
	{
		public static const ACTION_ADDED:String = "actionAdded";
		public static const ACTION_REMOVED:String = "actionRemoved";
		
		private var _action:AbstractAction;
		
		public function get action():AbstractAction {
			return _action;
		}
		
		public function ActionContainerDecoratorEvent(type:String, action:AbstractAction)
		{
			super(type, false, false);
			this._action = action;
		}
		
		override public function clone():Event {
			return new ActionContainerDecoratorEvent(this.type, this.action);
		}
	}
}