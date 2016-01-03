package uiengine.datarenderer
{
	import mx.controls.*;
	import collections.*;
	
	public class DefaultControlMap extends ControlMap
	{
		public function DefaultControlMap()
		{
			this.add(new ControlMapItem("String", TextArea, "text"));
			this.add(new ControlMapItem("int", NumericStepper, "value", false));
			this.add(new ControlMapItem("Date", DateField, "selectedDate", false));
		}
		
		public static function getInstance():DefaultControlMap
		{
			return Singleton.getInstance(DefaultControlMap) as DefaultControlMap;
		}
	}
}