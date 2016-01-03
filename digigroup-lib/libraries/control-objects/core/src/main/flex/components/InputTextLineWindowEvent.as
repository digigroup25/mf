package components
{
	import flash.events.Event;

	public class InputTextLineWindowEvent extends Event
	{
		public static const TEXT_ADDED:String = "text_added";
		
		private var _text:String;
		public function get text():String {
			return _text;
		}
		
		public function InputTextLineWindowEvent(type:String, text:String)
		{
			super(type, false, false);
			this._text = text;
		}
		
	}
}