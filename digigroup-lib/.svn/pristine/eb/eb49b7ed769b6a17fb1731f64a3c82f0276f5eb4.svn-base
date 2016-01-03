package uiengine.datarenderer
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mf.framework.*;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.Container;
	
	public class Render implements IManagedLifecycle
	{
		public var parent:DisplayObjectContainer;
		public var watchers:Array;
		public var view:Object;
		public var model:Object;
		
		public function Render(view:Object, model:Object, parent:DisplayObjectContainer, 
			watchers:Array) {
			//super(null, model);
			this.view = view;
			this.parent = parent;
			this.watchers = watchers;
		}
		
		public function initialize():void {
			//super.initialize();
			if ((parent!=null) && (parent!=view))
				parent.addChild(DisplayObject(view));
		}
		
		public function uninitialize():void {
			for each(var watcher:ChangeWatcher in watchers) {
				watcher.unwatch();
			}
			//if a renderer, uninitialize
			try {
				view.uninitialize();
			}
			catch (e:Error){}
			//if (parent!=null)
			//	parent.removeChild(DisplayObject(view));
			//Container(view).removeAllChildren();
			if (parent!=null){
				Container(parent).removeAllChildren();
				parent=null;
			}
			//super.uninitialize();
		}
	}
}