package mindmaps.map.ui.tree
{
	import mf.framework.IContainer;
	import mf.framework.IMessageBroker;
	
	public interface IContainerManager
	{
		function getLabel():String;
		function getObject():Object;
		function create():IContainer;
		function destroy(container:IContainer):void;			
	}
}