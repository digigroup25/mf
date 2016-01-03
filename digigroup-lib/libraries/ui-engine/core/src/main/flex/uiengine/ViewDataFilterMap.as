package uiengine
{
	import collections.*;
	
	import commonutils.ClassInspector;
	
	import reflection.*;
	
	import uiengine.datarenderer.*;
	
	public class ViewDataFilterMap extends Bag
	{
		private var mi:ModelInspector = new ModelInspector();
		private var ci:ClassInspector = new ClassInspector();
		
		public static function getInstance():ViewDataFilterMap
		{
			return Singleton.getInstance(ViewDataFilterMap) as ViewDataFilterMap;
		}
		
		//check for model[type]
		//check for voType
		public function getViewDataFilter(model:*, property:String, treatAsObject:Boolean):ViewDataFilter
		{
			for each (var vdfi:ViewDataFilterMapItem in source)
			{
				if ((vdfi.model==model) && (vdfi.property==property))
					return vdfi.viewDataFilter;				
			}

			var vo:* = mi.getModelVO(model, property, treatAsObject);
			return getViewDataFilterByVO(vo, treatAsObject);
		}
		
		//return a filter registered with vo
		//if no filter found, return empty filter
		public function getViewDataFilterByVO(vo:*, treatAsObject:Boolean=false):ViewDataFilter
		{
			var voType:Class = ci.getClass(vo);
			for each (var vdfi:ViewDataFilterMapItem in source)
			{
				if (vdfi.voType==voType)
					return vdfi.viewDataFilter;
				
			}
			return new ViewDataFilter();
		}
	}
}