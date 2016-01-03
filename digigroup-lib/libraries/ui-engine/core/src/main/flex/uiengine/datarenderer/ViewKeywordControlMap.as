package uiengine.datarenderer
{
	import collections.*;
	
	import mx.controls.*;
	
	public class ViewKeywordControlMap extends Bag
	{	
		public static function getInstance():ViewKeywordControlMap
		{
			return Singleton.getInstance(ViewKeywordControlMap) as ViewKeywordControlMap;
		}
		
		public function getControl(propertyKeyword:String):Class
		{
			for each (var tc:ViewKeywordControlMapItem in source)
			{
				if (tc.propertyKeyword==propertyKeyword)
					return tc.control;
			}
			return null;
		}
		
		public function addControl(propertyKeyword:String, control:Class):void {
			var item:ViewKeywordControlMapItem = new ViewKeywordControlMapItem(propertyKeyword, control);
			source.push(item);
		}
	}
}