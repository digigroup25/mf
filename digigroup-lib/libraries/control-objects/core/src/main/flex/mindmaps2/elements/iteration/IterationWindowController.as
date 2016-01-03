package mindmaps2.elements.iteration {
	import collections.TreeCollectionEx;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import mf.framework.AbstractController;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	import mf.framework.Message;

	import mindmaps.map.MapModel2;
	import mindmaps.map.ui.PopUpMessagesFactory;

	import mindmaps2.elements.iteration.IterationMessages;
	import mindmaps2.elements.ui.IterationInfoWindow;

	import mx.controls.Alert;
	import mindmaps2.elements.task.queries.TaskGroupPerformanceMetric;
	import mindmaps2.elements.task.queries.TaskGroupPerformanceMetricCalculator;

	public class IterationWindowController extends AbstractController {

		private static const taskGroupCalculator:TaskGroupPerformanceMetricCalculator = new TaskGroupPerformanceMetricCalculator();

		public function IterationWindowController(map:MapModel2, window:DisplayObjectContainer) {
			this.map = map;
			this.window = window;
			this.popupMessages = new PopUpMessagesFactory(this);
		}

		protected var map:MapModel2;

		private var popupMessages:PopUpMessagesFactory;

		private var window:DisplayObjectContainer;

		private var iterationStatusWindow:IterationInfoWindow;

		override public function receive(m:Message):void {
			switch (m.name) {
				case IterationMessages.SHOW_ITERATION_STATUS:
					onShowIterationStatus(m);
					break;
			}
		}

		private function onShowIterationStatus(m:Message):void {
			var node:TreeCollectionEx = TreeCollectionEx(m.body.node);

			if (m.sender != this) {
				iterationStatusWindow = new IterationInfoWindow();
				iterationStatusWindow.addEventListener("refresh", onIterationWindowRefresh, false, 0, true);
				this.send(popupMessages.addPopUp(iterationStatusWindow, "\"{0}\" Info", node.vo, "name"));
			}

			iterationStatusWindow.message = m;

			var taskGroupPerformanceMetric:TaskGroupPerformanceMetric = taskGroupCalculator.calculateGroupPerformance(node);
			iterationStatusWindow.metric = taskGroupPerformanceMetric;
		}

		private function onIterationWindowRefresh(event:Event):void {
			var message:Message = iterationStatusWindow.message;
			var newMessage:Message = message.clone();
			message.destroy();
			newMessage.sender = this;
			this.send(newMessage, true);
		}
	}
}
