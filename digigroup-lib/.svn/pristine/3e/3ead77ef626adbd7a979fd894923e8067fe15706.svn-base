package mindmaps.map.ui {
	import flash.display.DisplayObjectContainer;

	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.ViewContainerDecorator;

	import mindmaps.history.HistoryController;
	import mindmaps.map.MapContext;
	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.tree.components.TreeView2;

	import mindmaps2.elements.task.*;
	import mindmaps2.map.MindMapTreeContainer;
	import mindmaps2.map.controllers.MindMapController;
	import mindmaps2.map.ui.MindMapTreeEditor;
	import mindmaps2.map.ui.controllers.MindMapTreeKeyboardController;
	import mindmaps2.map.ui.controllers.NodeState;

	public class TreeContainer2Factory {

		public static function create(mb:IMessageBroker, map:MapModel2, parent:DisplayObjectContainer,
			label:String, mapContext:MapContext):Container2 {

			return createMindMapContainer(mb, map, parent, label, mapContext);
		}

		/*public static function createWithHistory(mb:IMessageBroker, map:MapModel2, parent:DisplayObjectContainer,
			viewDataFilterMap:ViewDataFilterMap, label:String):Container2 {

			var container:Container2 = new Container2(mb, map);
			var treeView:TreeView2 = new TreeView2();
			var res:ViewContainerDecorator = new ViewContainerDecorator(container, treeView);

			var editor:MindMapTreeEditor = new MindMapTreeEditor();
			var nodeState:NodeState = new NodeState(); //node state shared among controller
			var viewContainer:Container2 = new Container2(mb, treeView,
				[
				new NodeInteractionController(map, parent, viewDataFilterMap, label, nodeState),
				new MindMapTreeKeyboardController(editor, nodeState)

				]);
			viewContainer.name = "view";

			var modelContainer:Container2 = new Container2(mb, map,
				[
				new MindMapController(),
				new HistoryController()
				]);
			modelContainer.name = "model";

			res.containers = [ viewContainer, modelContainer ];
			return res;
		}*/

		private static function createMindMapContainer(mb:IMessageBroker, map:MapModel2, parent:DisplayObjectContainer,
			label:String, mapContext:MapContext):Container2 {

			var treeView:TreeView2 = new TreeView2();
			parent.addChild(treeView);
			return new MindMapTreeContainer(mb, map, treeView.allNodes, mapContext, treeView.selectedNode);
		}
	}
}
