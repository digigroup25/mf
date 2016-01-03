package mindmaps2.elements.task {
	import collections.*;
	import collections.tree.*;

	import com.flextoolbox.events.TreeMapEvent;

	import commonutils.CharCode;

	import components.FloatingWindow;
	import components.FloatingWindowFactory;
	import components.IWindowShadeStack;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.*;

	import mf.framework.AbstractController;
	import mf.framework.Message;

	import mindmaps.elementderivatives.subway.Subway;
	import mindmaps.elementderivatives.subway.TreeToSubwayConverter;
	import mindmaps.elementderivatives.subway.components.SubwayChartWithLegend;
	import mindmaps.map.MapModel2;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.ui.PopUpMessagesFactory;
	import mindmaps.map.ui.actions.messages.*;
	import mindmaps.map.ui.tree.components.*;

	import mindmaps2.elements.node.operations.NodeService;
	import mindmaps2.elements.task.operations.TaskService;
	import mindmaps2.elements.task.queries.*;
	import mindmaps2.elements.ui.IterationInfoWindow;
	import mindmaps2.elements.ui.PrioritizeWindow;

	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Tree;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.utils.StringUtil;

	public class TaskWindowController extends AbstractController {

		private static const taskGroupCalculator:TaskGroupPerformanceMetricCalculator = new TaskGroupPerformanceMetricCalculator();

		private static const nodeService:NodeService = new NodeService();

		private static const taskService:TaskService = new TaskService();

		public function TaskWindowController(map:MapModel2, window:IWindowShadeStack) {
			this.map = map;
			this.mapMessages = new MapMessageFactory(this);
			this.nodeMessages = new NodeMessageFactory(this);
			this.popupMessages = new PopUpMessagesFactory(this);
		}

		protected var map:MapModel2;

		private var mapMessages:MapMessageFactory;

		private var nodeMessages:NodeMessageFactory;

		private var popupMessages:PopUpMessagesFactory;

		private const queries:QueryFactory = new QueryFactory();

		override public function receive(m:Message):void {
			switch (m.name) {
				case TaskMessages.PRIORITIZED:
					onPrioritized(m);
					break;
				case TaskMessages.REMOVED_DONE:
					onRemovedDone(m);
					break;
				case TaskMessages.SHOW_GROUP_INFO:
					onShowTaskInfo(m);
					break;
			}
		}

		protected function get thisView():TreeView2 {
			return TreeView2(model);
		}

		protected function get thisModel():MapModel2 {
			return MapModel2(this.map);
		}

		protected function get treeView():Tree {
			return Tree(thisView.allNodes.getChildAt(0));
		}

		protected function get selectedNode():TreeCollectionEx {
			return TreeCollectionEx(treeView.selectedItem);
		}

		private function onShowTaskInfo(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var taskInfoWindow:IterationInfoWindow = IterationInfoWindow(m.body.window);
			if (taskInfoWindow == null) {
				taskInfoWindow = new IterationInfoWindow();
				taskInfoWindow.addEventListener("refresh", onFloatingWindowRefresh, false, 0, true);
				this.send(popupMessages.addPopUp(taskInfoWindow, "\"{0}\" Info", node.vo, "name"));
			}

			taskInfoWindow.message = m;

			var taskGroupPerformanceMetric:TaskGroupPerformanceMetric = taskGroupCalculator.calculateGroupPerformance(node);
			taskInfoWindow.metric = taskGroupPerformanceMetric;
		}

		private function onRemovedDone(m:Message):void {
			var removedTasks:uint = m.body.removedTasks as uint;
			Alert.show(StringUtil.substitute("Removed {0} done tasks", removedTasks), "", Alert.OK | Alert.NONMODAL);
			this.send(mapMessages.RefreshMap());
		}

		private function onPrioritized(m:Message):void {
			this.onPrioritizeAsTreeList(m);
		}

		private function addWindow(window:UIComponent, node:TreeCollectionEx, fieldName:String):void {
			var message:String =  node == null ? "" : "\"{0}\" prioritized by " + fieldName;
			var object:Object = node == null ? null : node.vo;
			var objectPropertyName:String = node == null ? null : "name";
			this.send(popupMessages.addPopUp(window, message, object, objectPropertyName));
		}

		private function onPrioritizeAsTreeList(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);
			var sortedTree:TreeCollectionEx = TreeCollectionEx(m.body.data);
			var prioritizeWindow:PrioritizeWindow = PrioritizeWindow(m.body.window);
			var fieldName:String = m.body.fieldName as String;

			if (prioritizeWindow == null) /*(m.sender != this)*/ { //prioritizedWindow did not dispatch it, initialize prioritize window
				prioritizeWindow = new PrioritizeWindow();
				addWindow(prioritizeWindow, sortedTree, fieldName);
				prioritizeWindow.callLater(function():void {
					prioritizeWindow.taskTreeList.addEventListener(ListEvent.ITEM_CLICK, onNodeClick, false, 0, true);
					prioritizeWindow.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
					prioritizeWindow.addEventListener("refresh", onFloatingWindowRefresh, false, 0, true);
				});
			}
			prioritizeWindow.tree = sortedTree;
			prioritizeWindow.message = m.body.originalMessage;
			prioritizeWindow.fieldName = fieldName;
		}

		private function onFloatingWindowRefresh(event:Event):void {
			refreshWindow(FloatingWindow(event.target));
		}

		private function refreshWindow(window:FloatingWindow):void {
			var message:Message = window.message;
			var newMessage:Message = message.clone();
			message.destroy();
			newMessage.body.window = window;
			this.send(newMessage, true);
		}

		private function onNodeClick(event:ListEvent):void {
			var itemsControl:AdvancedDataGrid = AdvancedDataGrid(event.target);
			var node:TreeCollectionEx = TreeCollectionEx(itemsControl.selectedItem);
			var originalNode:TreeCollectionEx = node.originalNode;
			this.send(nodeMessages.SelectNode(originalNode, false)); //send original node b/c node is a copy
		}

		private function onKeyDown(event:KeyboardEvent):void {
			var key:uint = event.keyCode;
			var charCode:uint = event.charCode;
			var window:PrioritizeWindow = PrioritizeWindow(event.currentTarget);
			var node:TreeCollectionEx = TreeCollectionEx(window.taskTreeList.selectedItem);

			if ((key == Keyboard.DELETE) || (key == Keyboard.BACKSPACE)) {
				deleteNode(window, node);
			} else if (CharCode.isEqual(charCode, 'd', true)) {
				markTaskAsDone(window, node);
				event.stopImmediatePropagation(); //prevent from selecting a node that starts with 'd'
			} else if (charCode >= CharCode.getCharCode('0') && charCode <= CharCode.getCharCode('9')) {
				var rating:uint = parseInt(String.fromCharCode(charCode)) as uint;
				setTaskRating(window, node, rating);
				event.stopImmediatePropagation(); //prevent from selecting a node that starts with a digit
			}
		}

		private function deleteNode(window:PrioritizeWindow, selectedNode:TreeCollectionEx):void {
			if (!selectedNode)
				return;
			var originalNode:TreeCollectionEx = selectedNode.originalNode || null;
			if (!originalNode)
				return;
			var nodeLocation:NodeLocation = nodeService.getNodeLocation(originalNode, this.map.nodes);
			if (!nodeLocation)
				return;
			this.send(nodeMessages.RemoveNode(originalNode, nodeLocation));

			refreshWithDelay(window);
		}

		private function refreshWithDelay(window:PrioritizeWindow):void {
			var delayedRefresh:uint = setInterval(function():void {
				refreshWindow(window);
				clearInterval(delayedRefresh);
			},
			500);
		}

		private function markTaskAsDone(window:PrioritizeWindow, selectedNode:TreeCollectionEx):void {
			taskService.markAsDone(selectedNode);

			refreshWithDelay(window);
		}

		private function setTaskRating(window:PrioritizeWindow, selectedNode:TreeCollectionEx, rating:uint):void {

			taskService.setRating(selectedNode, rating);

			refreshWithDelay(window);
		}
	/*private function setWindowSize(window:UIComponent):void {
		const parentHeight:int = window.parent.height;
		const parentWidth:int = window.parent.width;
		var width:int = parentWidth * 0.6;
		var height:int = parentHeight * 0.6;
		if (width < 300 || height < 200) {
			width = 300;
			height = 200;
		}
		window.width = width;
		window.height = height;
		var x:int = parentWidth / 2 - width / 2;
		var y:int = parentHeight / 2 - height / 2;
		window.x = x;
		window.y = y;
	}
*/
	}
}
