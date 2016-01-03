package mindmaps2
{
	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.AbstractUserAction;
	
	import collections.IIterator;
	
	import flash.display.MovieClip;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.Message;
	
	import mindmaps.map.MapContext;
	import mindmaps.map.ui.tree.MainContainer;
	import mindmaps.map.ui.tree.containers.Main;
	
	import mx.utils.StringUtil;

	public class ApplicationContainer2 extends Container2
	{
		
		private var view:Main;
		private var applicationContainerContext:ApplicationContainerContext;
		
		private function get rootAction():AbstractAction {
			return AbstractAction(model);
		}
		
		public function ApplicationContainer2(mb:IMessageBroker, view:Main, mapContext:MapContext, 
			rootAction:AbstractAction, applicationContainerContext:ApplicationContainerContext)
		{
			super(mb, rootAction);
			this.view = view;
			this.applicationContainerContext = applicationContainerContext;
			this.containers = [new MainContainer(view, mapContext, mb, rootAction)];	
		}
		
		override protected function doInitialize():void {
			super.doInitialize();
			
			var it:IIterator = rootAction.createIterator();
			while (it.hasNext()) {
				var action:AbstractAction = AbstractAction(it.next());
				if (action is AbstractIOAction) {
					AbstractIOAction(action).input.invocationContainer = this;
				}	
			}
			
			rootAction.initialize();
			
			//execute open map action
			AbstractUserAction(rootAction.children[0]).userExecute();
			
			showCompilationDateInContextMenu();
		}
		
		private function showCompilationDateInContextMenu():void {
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			
			menu.customItems.push(new ContextMenuItem(applicationContainerContext.compiledOn, true));
			this.view.contextMenu = menu;
			MovieClip(view.systemManager).contextMenu = menu.clone();
		}
	}
}