package mindmaps2.map {
	import flash.display.DisplayObjectContainer;

	import mf.framework.*;

	import mindmaps.importexport.MapImportExportController;
	import mindmaps.inputqueue.InputQueueContainer;
	import mindmaps.map.MapContext;
	import mindmaps.map.MapContextFactory;
	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.PopUpController;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.statistics.StatisticsController;

	import mindmaps2.elements.task.TaskMessages;
	import mindmaps2.elements.ui.controllers.NodeActionController;
	import mindmaps2.map.controllers.MindMapController;
	import mindmaps2.map.controllers.MindMapObserverController;
	import mindmaps2.map.ui.MindMapTreeEditor;
	import mindmaps2.map.ui.controllers.MindMapTreeKeyboardController;
	import mindmaps2.map.ui.controllers.MindMapTreeViewController;
	import mindmaps2.map.ui.controllers.NodeState;

	public class MindMapTreeContainer extends ViewContainer {

		public function MindMapTreeContainer(mb:IMessageBroker, map:MapModel2, parent:DisplayObjectContainer, mapContext:MapContext
			, detailsParent:DisplayObjectContainer) {
			super(mb, null, parent);
			this.map = map;
			this.parent = parent;
			if (mapContext == null)
				mapContext = new MapContextFactory().createDefault();
			this._mapContext = mapContext;

			var nodeState:NodeState = new NodeState();
			editor = new MindMapTreeEditor();

			viewController = new MindMapTreeViewController(parent, this, editor, map, nodeState, mapContext, detailsParent);

			this.controllers = [ viewController
				, new MindMapTreeKeyboardController(editor, nodeState)
				, new MindMapController(this.modelProvider)
				, new MindMapObserverController(editor)
				, new MapImportExportController()
				, new PopUpController(parent)
				, new StatisticsController(parent)
				, new NodeActionController(this.modelProvider)];

			var inputQueueContainer:Container2 = new InputQueueContainer(mb, map);
			this.containers = [ inputQueueContainer ];
		}

		public var map:MapModel2;

		private var editor:MindMapTreeEditor;

		private var parent:DisplayObjectContainer;

		private var viewController:MindMapTreeViewController;

		private var _mapContext:MapContext;

		public function get mapId():String {
			return map.name;
		}

		public function get mapContext():MapContext {
			return _mapContext;
		}

		override protected function doInitialize():void {
			super.doInitialize();
		}

		override protected function doFocus():void {
			viewController.focus();
		}

		override protected function doUninitialize():void {
			this.mb.disconnectAll(); //remove all connectors
			super.doUninitialize();
		}

		private function get editorGetter():MindMapTreeEditor {
			return editor;
		}
	}
}
