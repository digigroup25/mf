package mindmaps.importexport {
	import collections.TreeCollectionEx;

	import components.TextImportExportEvent;
	import components.TextOutputComponent;

	import converters.XmlCollectionConverter;

	import flash.events.MouseEvent;

	import mf.framework.AbstractController;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.PopUpMessagesFactory;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.elements.task.TaskMessageFactory;
	import mindmaps2.elements.task.TaskMessages;
	import mindmaps2.map.ui.MindMapMessageFactory;
	import mindmaps2.map.ui.MindMapMessages;

	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;

	public class MapImportExportController extends AbstractController {
		private static const indentationSeparator:String = "    ";

		private static const mapTextExporter:MapTextExporter = new MapTextExporter(indentationSeparator);

		public function MapImportExportController() {
			this.popupMessages = new PopUpMessagesFactory(this);
			this.mapMessages = new MindMapMessageFactory(this);
			this.nodeMessages = new NodeMessageFactory(this);
			this.taskMessages = new TaskMessageFactory(this);
		}

		private var popupMessages:PopUpMessagesFactory;

		private var mapMessages:MindMapMessageFactory;

		private var nodeMessages:NodeMessageFactory;

		private var taskMessages:TaskMessageFactory;

		private var map:MapModel2;

		override public function receive(m:Message):void {
			switch (m.name) {
				case MindMapMessages.EXPORT_MAP_TO_XML:
					onExportToXmlMap(m);
					break;
				case MindMapMessages.EXPORT_MAP_TO_TEXT:
					onExportToTextMap(m);
					break;
				case MindMapMessages.IMPORT_MAP:
					onImportMap(m);
					break;
				case NodeMessages.IMPORT_NODE:
					onImportNode(m);
					break;
				case NodeMessages.EXPORT_NODE:
					onExportNode(m);
					break;
				case TaskMessages.EXPORT_DONE:
					onExportDone(m);
					break;
				case TaskMessages.FILTERED_DONE:
					onFilteredDone(m);
					break;
			}
		}

		private function onImportNode(m:Message):void {
			showWindow("Import", "", onImportNodeSubmit, "Import");
		}

		private function onImportNodeSubmit(event:TextImportExportEvent):void {
			var window:TextOutputComponent = TextOutputComponent(event.currentTarget);
			var text:String = window.text;
			var importer:IMapImporter = new MapImporterFactory().createImporterFor(text);
			var tree:TreeCollectionEx = importer.importFrom(text);
			this.send(this.nodeMessages.ImportedNode(tree));
			this.send(this.popupMessages.removePopUp(window));
		}

		private function onImportMap(m:Message):void {
			showWindow("Import", "", onImportMapSubmit, "Import");
		}

		private function onImportMapSubmit(event:TextImportExportEvent):void {
			var window:TextOutputComponent = TextOutputComponent(event.currentTarget);
			var text:String = window.text;
			var importer:IMapImporter = new MapImporterFactory().createImporterFor(text);
			var tree:TreeCollectionEx = importer.importFrom(text);
			this.send(this.mapMessages.Imported(tree));
			this.send(this.popupMessages.removePopUp(window));
		}

		private function onExportNode(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var exportedText:String = mapTextExporter.exportNode(node);
			showWindow("Export to text", exportedText, onExportSubmit, "Close");
		}

		private function onExportToXmlMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			var converter:XmlCollectionConverter = new XmlCollectionConverter();
			var res:XML = converter.toXml(map.nodes);
			var exportedText:String = res.toXMLString();
			showWindow("Export to text", exportedText, onExportSubmit, "Close");
		}

		private function onExportToTextMap(m:Message):void {
			var map:MapModel2 = MapModel2(m.body.map);
			var exporter:MapTextExporter = new MapTextExporter();
			var exportedText:String = exporter.export(map);
			showWindow("Export to text", exportedText, onExportSubmit, "Close");
		}

		private function showWindow(windowTitle:String, text:String,
			submitHandler:Function, buttonLabel:String, closeHandler:Function = null):TextOutputComponent {
			var window:TextOutputComponent =  new TextOutputComponent();

			this.send(popupMessages.addPopUp(window, windowTitle, null, null));

			//set properties after window has been added to display list
			window.defaultButtonLabel = buttonLabel;
			window.showCloseButton = true;
			window.addEventListener(CloseEvent.CLOSE, closeHandler != null ? closeHandler : onClose);

			window.text = text;
			window.addEventListener(TextImportExportEvent.SUBMIT, submitHandler, false, 0, true);

			return window;
		}

		private function onExportSubmit(event:TextImportExportEvent):void {
			var window:TextOutputComponent = TextOutputComponent(event.currentTarget);
			this.send(this.popupMessages.removePopUp(window));
		}

		private function onClose(event:CloseEvent):void {
			var window:UIComponent = UIComponent(event.target);
			closeWindow(window);
		}

		private function closeWindow(window:UIComponent):void {
			window.removeEventListener(CloseEvent.CLOSE, onClose);
			this.send(popupMessages.removePopUp(window));
		}

		private function onExportDone(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			this.send(taskMessages.FilterDone(node));
		}

		private function onFilteredDone(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var exportedText:String = mapTextExporter.exportNode(node);
			showWindow("Export done tasks to text", exportedText, onExportDoneTasksSubmit, "Close", onExportDoneTasksClose);
		}

		private function onExportDoneTasksSubmit(event:TextImportExportEvent):void {
			var window:TextOutputComponent = TextOutputComponent(event.currentTarget);
			closeExportDoneTasksAndSendMessage(window);
		}

		private function closeExportDoneTasksAndSendMessage(window:UIComponent):void {
			this.send(this.popupMessages.removePopUp(window));
			this.send(taskMessages.ExportedDone());
		}

		private function onExportDoneTasksClose(event:CloseEvent):void {
			var window:UIComponent = UIComponent(event.target);
			closeExportDoneTasksAndSendMessage(window);
		}
	}
}
