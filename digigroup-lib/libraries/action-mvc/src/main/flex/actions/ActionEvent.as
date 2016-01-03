package actions
{
	import flash.events.Event;
	
	import mx.utils.StringUtil;

	public class ActionEvent extends Event
	{
		
		private var _targetAction:AbstractAction;
		private var _status:String;
		
		public static const STATUS_CHANGE:String = "statusChange";
		public static const UNABLE_TO_EXECUTE:String = "unableToExecute";
		
		public function get targetAction():AbstractAction {
			return _targetAction;
		}
		
		public function get status():String {
			return _status;
		}
		
		public function ActionEvent(type:String, targetAction:AbstractAction, status:String=null)
		{
			super(type, false, false);
			this._targetAction = targetAction;
			this._status = status;
		}
		
		public override function clone():Event {
			return new ActionEvent(this.type, targetAction, status);
		}
		
		public override function toString():String {
			return StringUtil.substitute("target action: {0}", this.targetAction.toString());
		}
	}
}