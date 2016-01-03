package uiengine.datarenderer
{
	public class DataRendererContext
	{
		public var vo:*;
		public var viewDataFilter:ViewDataFilter;
		public var container:*;
		public var showLabels:Boolean;
		public var useObjectHandles:Boolean;
		public var defaultEventHandling:Boolean = false;
		public var watchers:Array = new Array();
		public var controlName:String;
		public var changeHandler:Function; //gets called when a property value 
											//on model or view is changed
											
		public function DataRendererContext(vo:*, container:*=null, 
			viewDataFilter:ViewDataFilter=null, showLabels:Boolean=true, 
			useObjectHandles:Boolean=false, controlName:String=null, 
			changeHandler:Function=null)
		{
			this.vo=vo;
			this.container=container;
			this.viewDataFilter=viewDataFilter;
			this.showLabels = showLabels;
			this.useObjectHandles = useObjectHandles;
			this.controlName = controlName;
			this.changeHandler = changeHandler;
		}
	}
}