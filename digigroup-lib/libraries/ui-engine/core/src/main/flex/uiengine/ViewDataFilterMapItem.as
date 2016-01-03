package uiengine
{
	import uiengine.datarenderer.ViewDataFilter;
	
	public class ViewDataFilterMapItem
	{
		public var model:*;
		public var property:String;
		public var voType:*;
		public var viewDataFilter:ViewDataFilter;

		public function ViewDataFilterMapItem(model:*, property:String, vo:*, viewDataFilter:ViewDataFilter)
		{
			this.model=model;
			this.property=property;
			this.voType=vo;
			this.viewDataFilter=viewDataFilter;
			
		}
	}
}