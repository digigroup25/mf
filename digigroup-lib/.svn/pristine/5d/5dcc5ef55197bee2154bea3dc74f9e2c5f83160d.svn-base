package mindmaps2.elements.ui
{
	import flash.events.Event;
	
	public class ConvertElementWindowEvent extends Event
	{
		public static const CONVERT:String = "convert";
		
		private var _convertElementToType:Class;
		public function get convertElementToType():Class {
			return _convertElementToType;
		}
		public function ConvertElementWindowEvent(convertElementToType:Class)
		{
			super(CONVERT, true, true);
			this._convertElementToType = convertElementToType;
		}
		
		override public function clone():Event {
			return new ConvertElementWindowEvent(this.convertElementToType);
		}
	}
}