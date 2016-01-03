package mf.framework
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class ViewContainerDecorator extends ContainerDecorator
	{
		protected var viewProvider:IModelProvider;
		
		public function ViewContainerDecorator(container:Container2, view:DisplayObject)
		{
			super(container);
			this.viewProvider = new ModelProvider(view);
		}
		
		public function get view():DisplayObject {
			return DisplayObject(viewProvider.model);
		}
		
		public function set view(value:DisplayObject):void {
			viewProvider.model = value;
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
				if (container is ContainerDecorator) {
					//ViewContainer(container).focus();
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
		
		override public function toString():String {
			return "ViewContainerDecorator";
		}
	}
}