package mindmaps.map.ui.tree {
	import actions.AbstractAction;

	import flash.display.DisplayObject;

	import mf.framework.Container2;
	import mf.framework.IContainer;
	import mf.framework.IMessageBroker;
	import mf.framework.messaging.IncludeMessageFilter;

	import mindmaps.map.MapContext;
	import mindmaps.map.MapContextFactory;
	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.components.TreeTabNavigator;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;
	import mindmaps.search.SearchMessages;

	import mindmaps2.storage.MapStorageMessages;

	public class TreeContainerManager implements IContainerManager {

		public function TreeContainerManager(map:MapModel2, tabNavigator:TreeTabNavigator,
			tabMb:IMessageBroker, rootAction:AbstractAction) {
			this.map = map;
			this.tabNavigator = tabNavigator;
			this.tabMb = tabMb;
			this.rootAction = rootAction;
		}

		private var tabNavigator:TreeTabNavigator;

		private var map:MapModel2;

		private var tabMb:IMessageBroker;

		private var rootAction:AbstractAction;

		public function getLabel():String {
			return map.name;
		}

		public function getObject():Object {
			return map;
		}

		public function create():IContainer {
			var containerMb:IMessageBroker = TreeConfiguration.getDefaultMessageBroker();

			var mapContext:MapContext = new MapContextFactory().createDefault();
			var c:IContainer = new TreeMenuContainer( /*tabMb*/containerMb, map, mapContext, tabNavigator, map.name, rootAction
				);

			c.initialize();

			//connect internal container's message adapter to tabNavigator's mb
			//do not allow any messages to pass to the container
			//but allow any messages from the container
			tabMb.connect(containerMb, false, new IncludeMessageFilter(
				[ MapMessages.CLOSED_MAP, SearchMessages.SEARCH, MapStorageMessages.SAVE_MAP ]
				));
			return c;
		}

		public function destroy(container:IContainer):void {
			var c:TreeMenuContainer = TreeMenuContainer(container);


			if (tabNavigator.contains(DisplayObject(c.view)))
				tabNavigator.removeChild(DisplayObject(c.view));

			c.uninitialize(); //uninitialize after remove a child
		}
	}
}
