package uiengine.datarenderer
{
	import collections.*;
	
	import mx.controls.*;
	
	public class ControlMap extends Bag
	{
		public override function add(item:*):void
		{
			for (var i:int=0; i<source.length; i++)
			{
				if (source[i].type==item.type)
				{
					source[i] = item;
					return;
				}	
			}
			//nothing found, add
			source.push(item);
		}	
		public function getControl(type:String):Class
		{
			for each (var tc:ControlMapItem in source)
			{
				if (tc.type==type)
					return tc.control;
			}
			return TextArea;
		}
		
		public function getControlValue(type:String):Object
		{
			for each (var tc:ControlMapItem in source)
			{
				if (tc.type==type)
					return tc.controlValue;
			}
			return "text";
		}
		
		public function getControlValueByControlClass(controlClass:Class):String
		{
			for each (var tc:ControlMapItem in source)
			{
				if (tc.control==controlClass)
					return tc.controlValue;
			}
			return "text";
		}
		
		public function getType(control:Class):String
		{
			for each (var tc:ControlMapItem in source)
			{
				if (tc.control==control)
					return tc.type;
			}
			return null;
		}
		
		public function allowsObjectHandles(control:Class):Boolean
		{
			for each (var tc:ControlMapItem in source)
			{
				if (tc.control==control)
					return tc.useObjectHandles;
			}
			return false;
		}
		
		public function getControlMapItemByType(type:String):ControlMapItem {
			for each (var tc:ControlMapItem in source)
			{
				if (tc.type==type)
					return tc;;
			}
			return null;
		}
	}
}