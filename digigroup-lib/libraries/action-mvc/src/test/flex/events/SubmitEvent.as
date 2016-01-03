package events
{
	import flash.events.Event;

	public class SubmitEvent extends Event
	{
		public static const SUBMIT:String = "submit";
		public static const CANCEL:String = "cancel";
		
		private var _data:String;
		public function get data():String {
			return _data;
		}
		
		public function SubmitEvent(type:String, data:String=null)
		{
			super(type, true, false);
			this._data = data;
		}
		
	}
}