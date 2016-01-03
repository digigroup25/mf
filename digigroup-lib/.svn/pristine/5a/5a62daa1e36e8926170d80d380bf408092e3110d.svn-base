package mindmaps2.map.ui.controllers {
	import actions.AbstractUserAction;

	import assertions.Require;

	import collections.TreeCollectionEx;

	import commonutils.ClassInspector;

	import components.IWindowShade;
	import components.IWindowShadeStack;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mf.framework.AbstractController;
	import mf.framework.Message;
	import mf.framework.ViewContainer;

	import mindmaps.map.MapContext;
	import mindmaps.map.MapModel2;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;

	import mindmaps2.elements.MindMapDetailsContainer;
	import mindmaps2.elements.node.operations.NodeService;
	import mindmaps2.map.ui.MindMapMessageFactory;
	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.map.ui.MindMapTreeEditor;
	import mindmaps2.map.ui.MindMapTreeEditorEvent;

	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.PropertyChangeEvent;

	public class MindMapTreeViewController extends AbstractController {

		private static const nodeService:NodeService = new NodeService();

		public function MindMapTreeViewController(parent:DisplayObjectContainer, viewContainer:ViewContainer, editor:MindMapTreeEditor, map:MapModel2, nodeState:NodeState, mapContext:MapContext, detailsParent:DisplayObjectContainer) {
			this.parent = parent;
			this.viewContainer = viewContainer;
			this.editor = editor;
			this.map = map;
			this.nodeState = nodeState;
			this.mapContext = mapContext;
			this.detailsParent = detailsParent;

			this.nodeMessages = new NodeMessageFactory(this);
			this.mapMessages = new MapMessageFactory(this);
			this.mindMapMessages = new MindMapMessageFactory(this);

		}

		private var editorShade:IWindowShade;

		private var editor:MindMapTreeEditor;

		private var parent:DisplayObjectContainer;

		private var nodeState:NodeState;

		private var map:MapModel2;

		private var mapContext:MapContext;

		private const ci:ClassInspector = new ClassInspector();

		private var detailsParent:DisplayObjectContainer;

		private var nodeMessages:NodeMessageFactory;

		private var mapMessages:MapMessageFactory;

		private var mindMapMessages:MindMapMessageFactory;

		private var selectedNode:TreeCollectionEx;

		private var viewContainer:ViewContainer;

		override public function initialize():void {
			super.initialize();

			editor.dataProvider = map;
			editor.elementsToAdd = createMenuElements(mapContext.nodeTypes);


			//window.addEventListener(MindMapTreeEditorEvent.FOCUS_IN, onFocusChanged);
			//window.addEventListener(MindMapTreeEditorEvent.FOCUS_OUT, onFocusChanged);

			editor.addEventListener(MindMapTreeEditorEvent.SELECTED_ELEMENT_CHANGED, onSelectedElementChanged);

			editor.addEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_BEGIN, onElementEditBegin);
			editor.addEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_END, onElementEditEnd);

			editor.addEventListener(MindMapTreeEditorEvent.ADD_ELEMENT, onAddElement);
			editor.addEventListener(MindMapTreeEditorEvent.DELETE_ELEMENT, onDeleteElement);

			//window.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			parent.addChild(editor);
		}

		override public function receive(m:Message):void {
			switch (m.name) {
				/*case TreeTabMessages.CLOSE_MAP_IN_TAB:
					onCloseMapInTab(m);
					break;*/
				case MindMapMessages.CLOSE_MAP:
					onCloseMap(m);
					break;
				case MindMapMessages.IMPORTED_MAP:
					onImportedMap(m);
					break;
				case NodeMessages.IMPORTED_NODE:
					onImportedNode(m);
					break;
				case NodeMessages.SELECT_NODE:
					onSelectNode(m);
					break;
				case NodeMessages.ADDED_NODE:
					onAddedNode(m);
					break;
				case NodeMessages.CONVERTED_NODE:
					onConvertedNode(m);
					break;
				case NodeMessages.REMOVED_NODE:
					onRemovedNode(m);
					break;
				case MindMapMessages.EXPAND_DESCENDANTS:
					onExpandDescendants(m);
					break;
			}
		}

		/* private function setCurrentNode(node:TreeCollectionEx):void {
			var node:TreeCollectionEx = TreeCollectionEx(this.editor.selectedItem);//TreeCollectionEx(MapModel2(editor.dataProvider).nodes);
			setElementAndSendMessage(node);
			//editor.setFocus();
		} */

		public function focus():void {
			//ViewContainer(this.container).setChildAsLast(parent, this.window);
		}

		override public function uninitialize():void {
			if (detailsContainer != null)
				detailsContainer.uninitialize();

			parent.removeChild(editor);

			editor.removeEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_BEGIN, onElementEditBegin);
			editor.removeEventListener(MindMapTreeEditorEvent.ELEMENT_EDIT_END, onElementEditEnd);

			editor.removeEventListener(MindMapTreeEditorEvent.ADD_ELEMENT, onAddElement);
			editor.removeEventListener(MindMapTreeEditorEvent.DELETE_ELEMENT, onDeleteElement);

			super.uninitialize();
		}

		private function get detailsContainer():MindMapDetailsContainer {
			return MindMapDetailsContainer(viewContainer.getContainerByName("detailsContainer"));
		}

		private function set detailsContainer(value:MindMapDetailsContainer):void {
			value.name = "detailsContainer";
			viewContainer.setContainerByName(value.name, value);
		}

		private function createMenuElements(elements:Array):Array {
			var res:Array = [];
			for each (var type:Class in elements) {
				var elementEntry:Object = { label: ci.getClassName(type, true), value: type };
				res.push(elementEntry);
			}
			return res;
		}

		private function onAddElement(event:MindMapTreeEditorEvent):void {
			//Alert.show("Add element " + (event.elementType!=null) ? event.elementType + "" : "");
			var parentNode:TreeCollectionEx = TreeCollectionEx(this.editor.selectedItem);
			if (parentNode == null || event.elementType == null)
				return;
			var m:Message = nodeMessages.NewNode(event.elementType, parentNode);
			this.send(m);
		}

		private function onDeleteElement(event:MindMapTreeEditorEvent):void {
			//Alert.show("Delete element " + ((event.node!=null) ? event.node.toString() : ""));
			var node:TreeCollectionEx = event.node;
			if (node == null)
				return;

			var nodeLocation:NodeLocation = nodeService.getNodeLocation(node, this.map.nodes);
			if (!nodeLocation)
				return;
			var m:Message = nodeMessages.RemoveNode(node, nodeLocation);
			this.send(m);
		}

		private function onEditorShadePropertyChange(event:PropertyChangeEvent):void {
			if (event.property == "opened" && this.detailsContainer) {
				this.detailsContainer.visible = this.editorShade.opened;
			}
		}

		private function onFocusChanged(event:MindMapTreeEditorEvent):void {
			var m:Message = new Message(event.type == MindMapTreeEditorEvent.FOCUS_IN ? MindMapMessages.FOCUS_MAP : MindMapMessages.UNFOCUS_MAP, this, { container: this.container });
			//Alert.show("Map focus " + m.name);
			this.send(m);
		}

		private function onImportedNode(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			Require.notNull(node, "node");
			if (node.vo.name == "") { //remove extra node in between node
				selectedNode.addChildren(node.children.source);
				node.removeAllChildren();
			} else {
				selectedNode.addChild(node);
			}

			editor.callLater(expandDescendantsOf, [ selectedNode ]);
		}

		private function onImportedMap(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			Require.notNull(node, "node");

			map.nodes = node;

			editor.dataProvider = map; //reset dataprovider
			editor.callLater(expandDescendantsOf, [ node ]);
		}

		private function onExpandDescendants(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body);
			if (node == null)
				node = map.nodes;
			expandDescendantsOf(node);
		}

		private function expandDescendantsOf(node:TreeCollectionEx):void {
			editor.expandDescendantsOf(node);
		}

		private function onRemovedNode(m:Message):void {
			editor.editor.invalidateList();
			var location:NodeLocation = NodeLocation(m.body.location);
			var nodeToSelectIndex:int = location.childNodeIndex < location.parentNode.numChildren - 1 ? location.childNodeIndex : location.parentNode.numChildren - 1;
			var nodeToSelect:TreeCollectionEx = nodeToSelectIndex == -1 ? location.parentNode : TreeCollectionEx(location.parentNode.getChildAt(nodeToSelectIndex));
			editor.selectedItem = nodeToSelect; //select item
			editor.callLater(setElementAndSendMessage, [ nodeToSelect, false ]);
		}

		private function onConvertedNode(m:Message):void {
			editor.editor.invalidateList();
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			editor.selectedItem = node; //select item
			editor.callLater(setElementAndSendMessage, [ node, false ]);
		}

		private function onSelectNode(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			editor.selectedItem = node; //highlight selected item in the tree
		}

		private function setElementAndSendMessage(node:TreeCollectionEx, userSelect:Boolean):void {
			this.selectedNode = node;
			setElement(node);
			this.send(new Message(NodeMessages.SELECTED_NODE, this, { node: node, mapContainer: this.viewContainer, elementContainer: detailsContainer, userSelect: userSelect }));
		}

		private function onSelectedElementChanged(event:MindMapTreeEditorEvent):void {
			trace("MindMapTreeViewController.onSelectedElementChanged");
			var element:TreeCollectionEx = TreeCollectionEx(editor.selectedItem);
			if (element == null)
				return;
			setElementAndSendMessage(element, true);
		}

		private function setElement(node:TreeCollectionEx):void {
			if (detailsContainer != null && !detailsContainer.uninitialized) {
				detailsContainer.setEditorTo(node);
				return;
			}

			if (detailsContainer != null) {
				detailsContainer.uninitialize();
			}

			detailsContainer = new MindMapDetailsContainer(mb, map, node, detailsParent);
			detailsContainer.initialize();
		}

		private function onCloseMapInTab(m:Message):void {
			this.send(mindMapMessages.CloseMap(MapModel2(m.body.map)), true);
		}

		private function onCloseMap(m:Message):void {
			//uncomment this line to show confirmation dialog
			//processConfirmationMessage(proceedWithMessage, m, "Unsaved changes to the map will be lost", "Close?", "Close");
		}

		private function processConfirmationMessage(proceed:Function, originalMessage:Message, confirmationMessage:String, confirmationTitle:String, confirmationActionTitle:String):void {
			var newMessage:Message = originalMessage.clone();
			newMessage.sender = this;
			originalMessage.destroy();
			Alert.yesLabel = confirmationActionTitle;
			const confirmMessageCloseHandler:Function = function(event:CloseEvent):void {
				if (event.detail == Alert.YES) {
					proceed(newMessage);
				}
			}
			Alert.show(confirmationMessage, confirmationTitle, Alert.YES | Alert.CANCEL, FlexGlobals.topLevelApplication as Sprite, confirmMessageCloseHandler);
		}

		private function proceedWithMessage(m:Message):void {
			this.send(m);
		}

		private function onElementEditBegin(event:MindMapTreeEditorEvent):void {

			trace("MindMapTreeVeiwController.onElementEditBegin");
			nodeState.state = NodeState.EDITING;
		}

		private function onElementEditEnd(event:MindMapTreeEditorEvent):void {
			trace("MindMapTreeVeiwController.onElementEditEnd");
			nodeState.state = NodeState.SELECTED;
		}

		private function onMouseDown(event:MouseEvent):void {

			var editorOwnsTarget:Boolean = editor.owns(DisplayObject(event.target));
			//trace("MindMapTreeVeiwController.onMouseDown", 	"editorOwnsTarget", editorOwnsTarget);

			if (!editorOwnsTarget) {
				var newEvent:MindMapTreeEditorEvent = new MindMapTreeEditorEvent(MindMapTreeEditorEvent.FOCUS_OUT);
				editor.dispatchEvent(newEvent);
			}
		}

		private function onAddedNode(m:Message):void {
			//trace("MindMapTreeVeiwController.onAddedNode", m.body.node);
			var addedNode:TreeCollectionEx = TreeCollectionEx(m.body.node);

			/*var selectNode:Boolean = true;
			if (m.body.token != null && m.body.token.selectNode != undefined) {
				selectNode = m.body.token.selectNode;
			}
			if (selectNode) {*/
			editor.selectItemToEdit(addedNode);
			this.setElementAndSendMessage(addedNode, false);
			//}
		}
	}
}
