package mf.framework
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	[Deprecated]
	public class ViewContainer extends Container2
	{
		protected var viewProvider:IModelProvider;
		
		public function get view():DisplayObject {
			return DisplayObject(viewProvider.model);
		}
		
		public function set view(value:DisplayObject):void {
			viewProvider.model = value;
		}
		
		public function ViewContainer(mb:IMessageBroker=null, model:Object=null,  view:DisplayObject=null, controllers:Array=null, messageHandler:Function=null, containers:Array=null)
		{
			this.viewProvider = new ModelProvider(view);
			super(mb, model, controllers, messageHandler, containers);
		}
		
		public function get visible():Boolean {
			return view.visible;
		}
		
		public function set visible(value:Boolean):void {
			view.visible = value;
		}
		
		public function focus():void {
			doFocus();
			for each (var container:Container2 in this.containers) {
				if (container is ViewContainer) {
					ViewContainer(container).focus();
				}
			}
		}
		
		protected function doFocus():void {
			//subclass need to implement this
		}
		
		public function setChildAsLast(parent:DisplayObjectContainer, child:DisplayObject):void {
			if ((!parent.contains(child)) || (parent.numChildren<=1))
				return;
			parent.setChildIndex(child, parent.numChildren-1); 
		}
	}
}