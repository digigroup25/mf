package mindmaps2.map.ui.controllers
{
	public class NodeState
	{
		public static const EDITING:String = "editing";
		public static const UNSELECTED:String = "unselected";
		public static const SELECTED:String = "selected";
		public static const UNDOING:String = "undoing";
		
		private var _state:String; 
		
		public function get state():String { return _state; }
		public function set state(value:String):void { 
			if (_state==value) return;
			_state=value; 
			trace("NodeState.state", state);
		}
		
		public function NodeState() {
			state = UNSELECTED;
		}

	}
}