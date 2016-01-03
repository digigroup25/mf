package mindmaps.map.ui.tree
{
	import mf.framework.IContainer;
	import mf.framework.IMessageBroker;
	
	import mindmaps.map.ui.tree.components.TreeTabNavigator;
	
	import mx.containers.TabNavigator;

	public class ContainerManager implements IContainerManager
	{
		private var containerType:Class;
		private var tabNavigator:TabNavigator;
		private var label:String;
		private var mb:IMessageBroker;
		public function ContainerManager(containerType:Class, tabNavigator:TreeTabNavigator, label:String, 
			mb:IMessageBroker=null)
		{
			this.containerType = containerType;
			this.tabNavigator = tabNavigator;
			this.label = label;
			this.mb = mb;
		}

		public function getLabel():String
		{
			return this.label;
		}
		
		public function getObject():Object
		{
			return null;
		}
		
		public function create():IContainer
		{
			var tabMb:IMessageBroker = (mb==null) ? TreeConfiguration.getDefaultMessageBroker() : mb;
			
			//var objectContainer:Container = new VBox();
			var c:IContainer = new containerType(/*objectContainer*/tabNavigator, tabMb, label);
			//c.view = objectContainer;//set view explicitly
			//tabNavigator.addChild(objectContainer);
			c.initialize();
			return c;
		}
		
		public function destroy(container:IContainer):void
		{
			container.uninitialize();
		}
		
	}
}