package mindmaps2.actions {
	import actions.*;

	import mf.framework.Container2;
	import mf.framework.Message;

	import mindmaps.inputqueue.InputQueueMessages;
	import mindmaps.map.MapFormat;
	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;

	import mindmaps2.AppSettings;
	import mindmaps2.map.ui.MindMapMessageFactory;
	import mindmaps2.actions.map.CloseMap;
	import mindmaps2.actions.map.DisplayMap;
	import mindmaps2.actions.map.SaveMap;
	import mindmaps2.actions.map.SelectMap2;
	import mindmaps2.actions.map.ShowMapDirectory;

	public class RootAction extends AbstractRepeatableAction {
		public function RootAction(name:String = null, repeat:int = 1) {
			super(name, repeat);
			this.type = ActionType.PARALLEL;
			/* var editCompositeAction:AbstractAction = new AbstractUserAction("Edit map", AppSettings.DEFAULT_REPEAT_COUNT);
			editCompositeAction.logicType = LogicType.AND;
			editCompositeAction.canExecuteNextActionWhileCurrentIsCompleting = true;
			editCompositeAction.addChildren([new OpenMap(), new EditMap()]);
			this.addChildren([new NewMap(), editCompositeAction]); */

			var showAndManageMaps:AbstractAction = new ActionFactory().createAction("showAndManageMaps",
				ActionType.SEQUENTIAL, LogicType.OR, AppSettings.INFINITE_REPEAT_COUNT, true);
			showAndManageMaps.keepExecutingOrActions = true;
			this.addChildren([ showAndManageMaps ]);


			var showMapDirectory:AbstractAction = new ShowMapDirectory();
			/* new ActionFactory().createAction("showMapDirectory",
				ActionType.SEQUENTIAL, LogicType.OR, 1, false); */

			var existingMaps:AbstractAction = new ActionFactory().createAction("existingMaps", ActionType.SEQUENTIAL,
				LogicType.OR, AppSettings.INFINITE_REPEAT_COUNT, false);
			existingMaps.keepExecutingOrActions = true;

			showAndManageMaps.addChildren([ showMapDirectory, existingMaps ]);


			var openToViewOrEditMap:AbstractAction = new ActionFactory().createAction("openToViewOrEditMap", ActionType.SEQUENTIAL,
				LogicType.AND, 1, false);
			existingMaps.addChildren([ new SelectMap2(), openToViewOrEditMap ]);

			var viewOrEditMap:AbstractAction = new ActionFactory().createAction("viewOrEditMap", ActionType.PARALLEL,
				LogicType.OR, 1, false);

			openToViewOrEditMap.addChildren([ new DisplayMap(), viewOrEditMap ]);


			var sendMessageFunction:Function = function(action:AbstractUserAction, message:Message):void {
				var container:Container2 = Container2(action.input.invocationContainer);
				container.send(message);
				action.forceComplete();
			}

			var exportToXML:AbstractUserAction = new AbstractUserAction("Export to XML", AppSettings.INFINITE_REPEAT_COUNT);

			var xmlExportFunction:Function = function(action:AbstractUserAction):void {
				var map:MapModel2 = MapModel2(action.input.map);
				var mindMapMessages:MindMapMessageFactory = new MindMapMessageFactory(action);
				sendMessageFunction(action, mindMapMessages.Export(map, MapFormat.XML));
			}

			exportToXML.doExecuteFunction = xmlExportFunction;

			var exportToText:AbstractUserAction = new AbstractUserAction("Export to text", AppSettings.INFINITE_REPEAT_COUNT);
			var textExportFunction:Function = function(action:AbstractUserAction):void {
				var map:MapModel2 = MapModel2(action.input.map);
				var mindMapMessages:MindMapMessageFactory = new MindMapMessageFactory(action);
				sendMessageFunction(action, mindMapMessages.Export(map, MapFormat.TEXT));
			}
			exportToText.doExecuteFunction = textExportFunction;

			var importFromXML:AbstractUserAction = new AbstractUserAction("Import", AppSettings.INFINITE_REPEAT_COUNT);
			var xmlImportFunction:Function = function(action:AbstractUserAction):void {
				var map:MapModel2 = MapModel2(action.input.map);
				var mindMapMessages:MindMapMessageFactory = new MindMapMessageFactory(action);
				sendMessageFunction(action, mindMapMessages.Import(map, MapFormat.XML));
			}
			importFromXML.doExecuteFunction = xmlImportFunction;

			var statistics:AbstractUserAction = new AbstractUserAction("Statistics", AppSettings.INFINITE_REPEAT_COUNT);
			var statisticsFunction:Function = function(action:AbstractUserAction):void {
				var map:MapModel2 = MapModel2(action.input.map);
				var mapMessages:MapMessageFactory = new MapMessageFactory(action);
				sendMessageFunction(action, mapMessages.Statistics(map));
			}
			statistics.doExecuteFunction = statisticsFunction;

			var inputQueue:AbstractUserAction = new AbstractUserAction("Add task to Inbox", AppSettings.INFINITE_REPEAT_COUNT);
			var inputQueueFunction:Function = function(action:AbstractUserAction):void {
				var map:MapModel2 = MapModel2(action.input.map);
				sendMessageFunction(action, new Message(InputQueueMessages.SHOW_INPUT_QUEUE, action, { map: map }));
			}
			inputQueue.doExecuteFunction = inputQueueFunction;

			viewOrEditMap.addChildren([ new SaveMap(), new CloseMap(), exportToXML, exportToText, importFromXML, statistics, inputQueue ]);

		}
	}
}
