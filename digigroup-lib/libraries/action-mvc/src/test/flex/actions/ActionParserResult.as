package actions
{


	import actions.AbstractAction;


	public class ActionParserResult
	{
		private var _action:AbstractAction;
		private var _status:String;
		private var _targetAction:AbstractAction;
		
		public function get action():AbstractAction {
			return _action;
		}
		
		public function get status():String {
			return _status;
		}
		
		public function get targetAction():AbstractAction {
			return _targetAction;
		}
		public function ActionParserResult(action:AbstractAction,
			status:String, targetAction:AbstractAction)
		{
			this._action = action;
			this._status = status;
			this._targetAction = targetAction;
		}

	}
}