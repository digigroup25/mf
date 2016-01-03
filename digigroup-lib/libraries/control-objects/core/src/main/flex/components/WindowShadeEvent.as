package components
{
	import flash.events.Event;

	public class WindowShadeEvent extends Event
	{
		public static const EXPAND:String = "expandWindowShade";
		public static const COLLAPSE:String = "collapseWindowShade";
		
		public function WindowShadeEvent(type:String)
		{
			super(type, true, false);
		}
		
		override public function clone():Event {
			return new WindowShadeEvent(this.type);
		}
	}
}