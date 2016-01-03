package components
{
	import flash.events.Event;

	public class TextImportExportEvent extends Event
	{
		public static const SUBMIT:String = "submitTextImportExport";
		private var _text:String;
		
		public function get text():String {
			return _text;
		}
		
		public function TextImportExportEvent(text:String)
		{
			super(SUBMIT, false, false);
			_text = text;
		}
		
	}
}