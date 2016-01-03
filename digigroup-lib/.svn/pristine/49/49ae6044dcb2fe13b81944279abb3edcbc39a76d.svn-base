package mindmaps2
{
	import actions.AbstractAction;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mf.framework.*;
	
	import mindmaps2.central.CentralContainer;
	import mindmaps2.central.ui.CentralArea;
	import mindmaps2.storage.MapStorageContainer2;
	import mindmaps2.ui.ApplicationController;
	import mindmaps2.ui.InteractiveMenuController;
	
	import mx.managers.ILayoutManagerClient;

	public class ApplicationContainer extends ViewContainer
	{
		private var centralContainer:ViewContainer;
		
		public function ApplicationContainer(mb:IMessageBroker, centralArea:CentralArea, rootAction:AbstractAction) {
			super(mb, null, centralArea, null, null, null);
			var interactiveMenuController:InteractiveMenuController = new AppSettings.interactiveMenuController(this.viewProvider, 
				mb, rootAction, this);
			
			var applicationController:ApplicationController = new ApplicationController(mb);
			centralContainer = new CentralContainer(centralArea, mb);
			var storageContainer:Container2 = new MapStorageContainer2(centralArea, mb, "Choose map to open");
			
			this.controllers = [interactiveMenuController, applicationController];
			this.containers = [centralContainer, storageContainer];
			
		}
		
		public function getContainerIntersectingPoint(point:Point):Object {
			var res:Object = null;
			var descendantContainers:Array = this.getDescendantContainers();
			var nestLevel:int = 0;
			for each (var container:Container2 in descendantContainers) {
				if (container is ViewContainer) {
					var view:DisplayObject = DisplayObject(ViewContainer(container).view);
					if (view.hitTestPoint(point.x, point.y) && 
						view is ILayoutManagerClient) {
						if (ILayoutManagerClient(view).nestLevel>nestLevel) {
							nestLevel = ILayoutManagerClient(view).nestLevel;
							res = {container:container, view:view};
						}
					}
				}
			}
			if (res==null) {
				res = {container:centralContainer, view:centralContainer.view};
			}
			return res;
		}
	}
}