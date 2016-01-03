package mindmaps2.elements {
	import collections.TreeCollectionEx;

	import commonutils.ClassInspector;

	import components.IWindowShadeStack;
	import components.WindowShadeStack;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.ViewContainer;
	import mf.framework.ViewContainerDecorator;

	import mindmaps.map.MapModel2;

	import mindmaps2.elements.iteration.IterationWindowController;
	import mindmaps2.elements.task.TaskController;
	import mindmaps2.elements.task.TaskWindowController;
	import mindmaps2.elements.ui.ElementEditorFactory;
	import mindmaps2.elements.ui.ElementEditorTemplate;

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.utils.StringUtil;

	public class MindMapDetailsContainer extends ViewContainerDecorator {

		public function MindMapDetailsContainer(mb:IMessageBroker, map:MapModel2, selectedNode:TreeCollectionEx,
			parent:DisplayObjectContainer) {
			var container:Container2 = new Container2(mb, map);
			//super(mb, null, new WindowShadeStack());
			var view:DisplayObject = new WindowShadeStack();
			super(container, view);
			this.map = map;
			this.parent = parent;
			this.node = selectedNode;

			this.controllers = [ new TaskWindowController(map, IWindowShadeStack(window)),
				new IterationWindowController(map, DisplayObjectContainer(window)),
				new TaskController()];
		}

		private var parent:DisplayObjectContainer;

		private var editor:ElementEditorTemplate;

		private var editorWrapper:Container;


		private const ci:ClassInspector = new ClassInspector();

		private var map:MapModel2;

		private const elementEditors:ElementEditorFactory = new ElementEditorFactory();

		private var node:TreeCollectionEx;

		public function setEditorTo(node:TreeCollectionEx):void {
			this.node = node;
			var newEditor:ElementEditorTemplate = elementEditors.createEditorFor(element);

			if (editor != null && ci.getClass(this.editor) == ci.getClass(newEditor)) { //keep current editor
				setCurrentElement();
				return;
			}

			removeEditor();
			editor = newEditor;
			addEditor();
		}

		override protected function doInitialize():void {
			parent.addChild(window);

			window.addEventListener(Event.CLOSE, onWindowClose);

			editor = elementEditors.createEditorFor(element);
			addEditor();

			super.doInitialize();
		}

		override protected function doFocus():void {
			this.setChildAsLast(parent, this.window);
		}

		override protected function doUninitialize():void {
			window.removeEventListener(Event.CLOSE, onWindowClose);

			parent.removeChild(window);

			//this.mb.disconnectAll();//remove all connectors
			super.doUninitialize();
		}

		private function get window():UIComponent {
			return UIComponent(this.view);
		}

		private function get element():Object {
			return node.vo;
		}

		private function addEditor():void {
			if (editor == null)
				return;
			editorWrapper = Container(IWindowShadeStack(window).addWindowShade(editor, false, false));
			editorWrapper.addEventListener(CloseEvent.CLOSE, onCloseEditor);
			setCurrentElement();

		}

		private function setCurrentElement():void {
			editor.dataProvider = element;
			editorWrapper.label = StringUtil.substitute("{0}: {1}", ci.getClassName(element, true), element.name);
		}

		private function onCloseEditor(event:CloseEvent):void {
			event.preventDefault();
			removeEditor();
		}

		private function removeEditor():void {
			if (editorWrapper != null) {
				IWindowShadeStack(window).removeWindowShade(editor);
				editorWrapper = null;
				editor = null;
			}
		}

		private function onWindowClose(event:Event):void {
			if (event.isDefaultPrevented())
				return;
			uninitialize();
		}
	}
}
